import requests
import urllib.parse
import json

# Base URL
base_url = "https://miss-blum.com/v1/api"

# Headers template (common for both endpoints)
headers = {
    "accept": "*/*",
    "accept-encoding": "gzip, deflate, br, zstd",
    "accept-language": "en-US,en;q=0.9",
    "content-type": "application/json",
    "origin": "https://miss-blum.com",
    "referer": "https://miss-blum.com/?menu=home",
    "sec-ch-ua": '"Microsoft Edge WebView2";v="135", "Chromium";v="135", "Not-A.Brand";v="8", "Microsoft Edge";v="135"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"Windows"',
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
}

def read_initdata():
    try:
        with open("data.txt", "r") as file:
            lines = file.readlines()
        return [line.strip() for line in lines if line.strip()]
    except FileNotFoundError:
        print("Gagal baca data.txt: File tidak ditemukan")
        return []
    except Exception as e:
        print(f"Gagal baca data.txt: {e}")
        return []

def extract_userid(initdata):
    try:
        parsed = urllib.parse.parse_qs(initdata)
        user_str = parsed.get("user", [None])[0]
        if not user_str:
            print("Gagal ekstrak userId: Tidak ada 'user' di initdata")
            return None
        
        user_data = json.loads(user_str)
        user_id = str(user_data.get("id"))
        if user_id:
            return user_id
        else:
            print("Gagal ekstrak userId: Tidak ada 'id' di user")
            return None
    except Exception as e:
        print(f"Gagal ekstrak userId dari initdata: {e}")
        return None

def get_session_token(user_id):
    try:
        session_payload = {"userId": user_id}
        response = requests.post(f"{base_url}/session", json=session_payload, headers=headers)
        if response.status_code == 201:
            try:
                session_token = response.json().get("token")
                if session_token:
                    print(f"[{user_id}] Berhasil ambil token")
                    return session_token
                else:
                    print(f"[{user_id}] Gagal ambil token: Token tidak ditemukan")
                    return None
            except ValueError:
                print(f"[{user_id}] Gagal ambil token: Respons tidak valid")
                return None
        else:
            print(f"[{user_id}] Gagal ambil token")
            return None
    except Exception:
        print(f"[{user_id}] Gagal ambil token: Koneksi bermasalah")
        return None

def add_tickets(user_id, session_token, tickets):
    try:
        ticket_headers = headers.copy()
        ticket_headers["cookie"] = f"session-token={session_token}"
        ticket_headers["referer"] = "https://miss-blum.com/?menu=lunaKim"
        ticket_payload = {"userId": user_id, "tickets": tickets}

        response = requests.post(f"{base_url}/user/addTickets", json=ticket_payload, headers=ticket_headers)
        if response.status_code == 201:
            print(f"[{user_id}] Berhasil tambah {tickets} tiket")
            return True
        else:
            print(f"[{user_id}] Gagal tambah tiket")
            return False
    except Exception:
        print(f"[{user_id}] Gagal tambah tiket: Koneksi bermasalah")
        return False

def main():
    initdata_list = read_initdata()
    if not initdata_list:
        print("Tidak ada akun untuk diproses. Pastikan data.txt ada dan tidak kosong.")
        return

    try:
        tickets = int(input("Masukkan jumlah tiket yang ingin ditambahkan: "))
        if tickets <= 0:
            print("Jumlah tiket harus lebih dari 0.")
            return
    except ValueError:
        print("Masukkan angka yang valid untuk jumlah tiket.")
        return

    print(f"Memproses {len(initdata_list)} akun...")
    for initdata in initdata_list:
        user_id = extract_userid(initdata)
        if not user_id:
            continue

        session_token = get_session_token(user_id)
        if not session_token:
            continue

        add_tickets(user_id, session_token, tickets)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nBerhenti atas perintah pengguna")