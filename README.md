# Born2BeRoot | เกิดเป็นราก

- Setup SSH เฉพาะ Port 4242 (ไม่ต้องเปิด 22) และทำให้ต่อผ่าน User root ไม่ได้
- ใช้ UFW เพื่อ Config ให้ allow เฉพาะ Port ของ SSH
- Set hostname ของเครื่องเป็น `<Intra>42` และต้องเปลี่ยนให้ได้ด้วย
- ตั้ง Policy ของการตั้งรหัสผ่านของ User ให้**ปลอดภัย**
  - รหัสผ่านต้องหมดอายุใน 30 วัน
  - ต้องรอ 2 วันก่อนถึงจะตั้งรหัสผ่านได้อีกครั้ง
  - User ต้องได้รับ Message ว่ารหัสจะหมดอายุภายใน 7 วันก่อนหมดอายุ
  - เงื่อนไขรหัสผ่าน
    - ขั้นต่ำ 10 ตัวอักษร
    - มีตัวใหญ่ 1 ตัว
    - มีตัวเล็ก 1 ตัว
    - มีตัวเลข 1 ตัว
    - ต้องไม่มีตัวอักษรซ้ำติดต่อกัน 3 ตัว
    - ต้องไม่มีชื่อ user ในรหัสผ่าน
    - รหัสผ่าน 7 ตัวต้องไม่ซ้ำกับรหัสผ่านเดิม (ยกเว้น root)
    - Root ต้องใช้กฏนี้ด้วย
- ลง sudo และ Setup ตามกฏ
  - ตอนใส่รหัส ให้ผิดได้ 3 ครั้ง
  - กำหนด Message เวลาใส่รหัสผิดเมื่อใช้ Sudo
  - ให้ Log `input` และ `output` ไปไว้ที่ ` /var/log/sudo/`
  - เปิด TTY
  - Sudo ต้อง access ได้แต่ path ดังนี้ `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`
- ต้องมี User ที่มีชื่อ Intra ของเรา และ Root ด้วย
- User ของเราต้องอยู่ใน Group `user42` และ `sudo` (ต้อง Assign user ใหม่เข้า 2 group ได้)
- สร้างไฟล์ `monitoring.sh` โดยใช้ `bash` และให้โชว์ทุกๆ 10 นาที (ใช้ wall) โชว์ Banner ก็ได้ แต่ห้าม Error ให้เห็น
  • The architecture of your operating system and its kernel version.
  • The number of physical processors.
  • The number of virtual processors.
  • The current available RAM on your server and its utilization rate as a percentage.
  • The current available memory on your server and its utilization rate as a percentage.
  • The current utilization rate of your processors as a percentage.
  • The date and time of the last reboot.
  • Whether LVM is active or not.
  • The number of active connections.
  • The number of users using the server.
  • The IPv4 address of your server and its MAC (Media Access Control) address.
  • The number of commands executed with the sudo program.
