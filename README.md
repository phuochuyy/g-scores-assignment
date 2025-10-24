# G-Scores

Ứng dụng web tra cứu điểm thi THPT Quốc gia 2024 được xây dựng bằng Ruby on Rails.

## Tính năng

- Tra cứu điểm thi theo số báo danh
- Thống kê điểm thi với biểu đồ
- Top 10 học sinh khối A
- API RESTful

## Tech Stack

- Ruby on Rails 8.0.3
- PostgreSQL 15
- Bootstrap 5.3.0
- Chart.js
- Docker

## Cài đặt

### Yêu cầu
- Docker & Docker Compose
- Git

### Chạy dự án

1. Clone repository
```bash
git clone <repository-url>
cd g-scores
```

2. Chạy với Docker
```bash
docker compose up -d
docker compose exec web rails db:migrate
docker compose exec web rails db:seed
```

3. Truy cập ứng dụng
- Web: http://localhost:3001
- API: http://localhost:3001/api/v1/

## Sử dụng

### Tra cứu điểm
- Truy cập http://localhost:3001
- Nhập số báo danh 8 chữ số
- Xem kết quả điểm thi

### Thống kê
- Truy cập http://localhost:3001/reports/statistics
- Click vào các môn học để xem biểu đồ

### Top học sinh
- Truy cập http://localhost:3001/reports/top_students
- Xem danh sách top 10 học sinh khối A

## API

- `GET /api/v1/students/:sbd` - Thông tin học sinh
- `GET /api/v1/reports/statistics` - Thống kê điểm thi
- `GET /api/v1/reports/top_students` - Top 10 khối A

## Demo

- **Live Demo**: https://delicate-sea-8642.fly.dev/

## Cấu trúc dự án

```
app/
├── controllers/     # Controllers
├── models/         # Models
├── services/       # Service objects
├── views/          # Views
└── helpers/        # Helpers

config/
├── routes.rb       # Routing
└── database.yml    # Database config

db/
├── migrate/        # Migrations
└── seeds.rb        # Seed data
```

## License

MIT License