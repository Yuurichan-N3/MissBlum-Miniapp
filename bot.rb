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

# Fungsi untuk membaca userId dari data.txt dengan format URL-encoded
def get_user_id_from_file(filename)
  begin
    content = File.read(filename).strip
    decoded_data = URI.decode_www_form_component(content)
    if decoded_data.include?('user=')
      user_part = decoded_data.split('user=')[1].split('&')[0]
      begin
        user_json = JSON.parse(user_part)
        user_id = user_json['id'].to_s
        return user_id if user_id && !user_id.empty?
        raise "Field 'id' tidak ditemukan di JSON user"
      rescue JSON::ParserError => e
        puts "Error parsing JSON: #{e}"
        return nil
      end
    else
      raise "'user=' tidak ditemukan di data.txt"
    end
  rescue Errno::ENOENT
    puts "File data.txt tidak ditemukan!"
    return nil
  rescue StandardError => e
    puts "Error membaca file: #{e}"
    return nil
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
          puts "Session berhasil diperbarui!"
          puts "Status code: 200"
          return token
        else
          puts "Token tidak ditemukan di response session!"
          puts "Status code: 400"
          return nil
        end
      rescue JSON::ParserError
        puts "Response session bukan JSON valid!"
        puts "Status code: 400"
        return nil
      end
    else
      puts "Gagal memperbarui session. Status code: #{response.code}"
      puts "Response: #{response.body}"
      return nil
    end
  rescue StandardError => e
    puts "Error saat mengirim request session: #{e}"
    puts "Status code: 400"
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
      puts "Task #{task_id} berhasil diselesaikan!"
      puts "Status code: 200"
      return true
    else
      puts "Gagal menyelesaikan task #{task_id}."
      puts "Status code: 400 (Server response: #{response.code})"
      puts "Response: #{response.body}"
      return false
    end
  rescue StandardError => e
    puts "Error saat mengirim request task #{task_id}: #{e}"
    puts "Status code: 400"
    return false
  end
end

# Main program
def main
  # Tampilkan banner
  puts BANNER
  
  user_id = get_user_id_from_file('data.txt')
  
  if user_id
    puts "User ID ditemukan: #{user_id}"
    
    # Generate daftar task dari 1 sampai 26
    tasks = (1..26).map { |i| "task-#{i.to_s.rjust(3, '0')}" }
    
    # Proses setiap task
    tasks.each do |task_id|
      puts "\nMemproses #{task_id}..."
      
      # Perbarui session
      token = update_session(user_id)
      if token
        # session sukses, eksekusi task
        execute_task(user_id, task_id, token)
      else
        puts "Menghentikan proses karena session gagal."
        break
      end
    end
  else
    puts "Gagal melanjutkan karena userId tidak ditemukan."
  end
end

main if $PROGRAM_NAME == __FILE__
