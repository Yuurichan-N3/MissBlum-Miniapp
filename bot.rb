require 'httparty'
require 'json'
require 'uri'

# Banner
BANNER = <<~BANNER
╔══════════════════════════════════════════════╗
║       🌟 MISS BLUM TASK AUTOMATOR            ║
║   Automate your task execution on Miss Blum! ║
║  Developed by: https://t.me/sentineldiscus   ║
╚══════════════════════════════════════════════╝
BANNER

# URL untuk session dan tasks/executed
URL_SESSION = "https://miss-blum.com/v1/api/session"
URL_TASKS_EXECUTED = "https://miss-blum.com/v1/api/tasks/executed"

# Headers
HEADERS = {
  "accept" => "*/*",
  "accept-encoding" => "gzip, deflate, br, zstd",
  "accept-language" => "en-US,en;q=0.9",
  "connection" => "keep-alive",
  "content-type" => "application/json",
  "host" => "miss-blum.com",
  "origin" => "https://miss-blum.com",
  "referer" => "https://miss-blum.com/?menu=home",
  "sec-ch-ua" => '"Microsoft Edge";v="134", "Chromium";v="134", "Not:A-Brand";v="24", "Microsoft Edge WebView2";v="134"',
  "sec-ch-ua-mobile" => "?0",
  "sec-ch-ua-platform" => '"Windows"',
  "sec-fetch-dest" => "empty",
  "sec-fetch-mode" => "cors",
  "sec-fetch-site" => "same-origin",
  "user-agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0"
}

# Fungsi untuk membaca semua userId dari data.txt
def get_user_ids_from_file(filename)
  user_ids = []
  begin
    lines = File.readlines(filename, chomp: true)
    lines.each_with_index do |line, index|
      next if line.empty?
      decoded_data = URI.decode_www_form_component(line)
      if decoded_data.include?('user=')
        user_part = decoded_data.split('user=')[1].split('&')[0]
        begin
          user_json = JSON.parse(user_part)
          user_id = user_json['id'].to_s
          if user_id && !user_id.empty?
            user_ids << user_id
          else
            puts "[Akun #{index + 1}] Field 'id' tidak ditemukan di JSON user"
          end
        rescue JSON::ParserError => e
          puts "[Akun #{index + 1}] Error parsing JSON: #{e}"
        end
      else
        puts "[Akun #{index + 1}] 'user=' tidak ditemukan di data"
      end
    end
    if user_ids.empty?
      puts "Tidak ada userId valid yang ditemukan di data.txt!"
    end
    user_ids
  rescue Errno::ENOENT
    puts "File data.txt tidak ditemukan!"
    []
  rescue StandardError => e
    puts "Error membaca file: #{e}"
    []
  end
end

# Fungsi untuk memperbarui session dan mendapatkan token baru
def update_session(user_id)
  payload = { "userId" => user_id }
  headers_session = HEADERS.dup
  headers_session["referer"] = "https://miss-blum.com/?menu=home"
  
  begin
    response = HTTParty.post(URL_SESSION, 
      headers: headers_session,
      body: payload.to_json
    )
    
    if response.code == 201
      begin
        response_data = JSON.parse(response.body)
        token = response_data["token"]
        if token
          puts "[Akun #{user_id}] Session berhasil diperbarui!"
          puts "[Akun #{user_id}] Status code: 200"
          return token
        else
          puts "[Akun #{user_id}] Token tidak ditemukan di response session!"
          puts "[Akun #{user_id}] Status code: 400"
          return nil
        end
      rescue JSON::ParserError
        puts "[Akun #{user_id}] Response session bukan JSON valid!"
        puts "[Akun #{user_id}] Status code: 400"
        return nil
      end
    else
      puts "[Akun #{user_id}] Gagal memperbarui session. Status code: #{response.code}"
      puts "[Akun #{user_id}] Response: #{response.body}"
      return nil
    end
  rescue StandardError => e
    puts "[Akun #{user_id}] Error saat mengirim request session: #{e}"
    puts "[Akun #{user_id}] Status code: 400"
    return nil
  end
end

# Fungsi untuk mengirim request tasks/executed
def execute_task(user_id, task_id, token)
  headers_task = HEADERS.dup
  headers_task["authorization"] = token
  headers_task["referer"] = "https://miss-blum.com/?menu=earn"
  payload = { "userId" => user_id, "taskId" => task_id }
  
  begin
    response = HTTParty.post(URL_TASKS_EXECUTED,
      headers: headers_task,
      body: payload.to_json
    )
    
    if response.code == 201
      puts "[Akun #{user_id}] Task #{task_id} berhasil diselesaikan!"
      puts "[Akun #{user_id}] Status code: 200"
      return true
    else
      puts "[Akun #{user_id}] Gagal menyelesaikan task #{task_id}."
      puts "[Akun #{user_id}] Status code: 400 (Server response: #{response.code})"
      puts "[Akun #{user_id}] Response: #{response.body}"
      return false
    end
  rescue StandardError => e
    puts "[Akun #{user_id}] Error saat mengirim request task #{task_id}: #{e}"
    puts "[Akun #{user_id}] Status code: 400"
    return false
  end
end

# Fungsi untuk memproses satu akun
def process_account(user_id, index, total_accounts)
  puts "\n[Proses #{index}/#{total_accounts}] Memproses akun dengan userId: #{user_id}"
  
  # Generate daftar task dari 1 sampai 26
  tasks = (1..26).map { |i| "task-#{i.to_s.rjust(3, '0')}" }
  
  # Proses setiap task
  tasks.each do |task_id|
    puts "\n[Akun #{user_id}] Memproses #{task_id}..."
    
    # Perbarui session
    token = update_session(user_id)
    if token
      # session sukses, eksekusi task
      execute_task(user_id, task_id, token)
    else
      puts "[Akun #{user_id}] Menghentikan proses karena session gagal."
      return { user_id: user_id, tasks_completed: 0 }
    end
  end
  
  { user_id: user_id, tasks_completed: tasks.length }
end

# Main program
def main
  # Tampilkan banner
  puts BANNER
  
  user_ids = get_user_ids_from_file('data.txt')
  
  if user_ids.empty?
    puts "Gagal melanjutkan karena tidak ada userId yang ditemukan."
    return
  end
  
  puts "\nDitemukan #{user_ids.length} akun untuk diproses."
  
  # Proses setiap akun
  results = []
  user_ids.each_with_index do |user_id, index|
    result = process_account(user_id, index + 1, user_ids.length)
    results << result
  end
  
  # Tampilkan ringkasan
  puts "\n=== Ringkasan ==="
  total_tasks_completed = results.sum { |r| r[:tasks_completed] }
  puts "Akun yang diproses: #{results.length}/#{user_ids.length}"
  puts "Total task selesai: #{total_tasks_completed}"
  results.each do |result|
    puts "Akun #{result[:user_id]}: #{result[:tasks_completed]} task selesai"
  end
end

main if $PROGRAM_NAME == __FILE__
