# G-Scores

Ứng dụng web tra cứu điểm thi THPT Quốc gia 2024 được xây dựng bằng Ruby on Rails.

## Mô tả

G-Scores là ứng dụng web cho phép tra cứu điểm thi THPT của học sinh, xem thống kê điểm thi và danh sách top học sinh khối A.

## Tính năng

- Tra cứu điểm thi theo số báo danh
- Thống kê điểm thi với biểu đồ tương tác
- Top 10 học sinh khối A
- API RESTful

## Tech Stack

- Ruby on Rails 8.0.3
- PostgreSQL 15
- Bootstrap 5.3.0
- Chart.js
- Docker

## Cài đặt

### Yêu cầu hệ thống

#### Phương pháp 1: Docker (Khuyến nghị)
- **Docker** >= 20.10.0
- **Docker Compose** >= 2.0.0
- **Git** >= 2.30.0
- **RAM**: Tối thiểu 2GB
- **Disk**: Tối thiểu 1GB trống

#### Phương pháp 2: Local Development
- **Ruby** >= 3.4.0
- **Rails** >= 8.0.3
- **PostgreSQL** >= 15.0
- **Node.js** >= 18.0.0 (cho asset pipeline)
- **Git** >= 2.30.0

### Cài đặt với Docker (Khuyến nghị)

#### Bước 1: Clone repository
```bash
# Clone dự án
git clone https://github.com/your-username/g-scores.git
cd g-scores

# Kiểm tra cấu trúc dự án
ls -la
```

#### Bước 2: Cấu hình môi trường
```bash
# Tạo file .env (tùy chọn)
cp .env.example .env

# Chỉnh sửa cấu hình nếu cần
nano .env
```

#### Bước 3: Build và chạy containers
```bash
# Build Docker images
docker compose build

# Chạy services (database + web)
docker compose up -d

# Kiểm tra trạng thái containers
docker compose ps
```

#### Bước 4: Thiết lập database
```bash
# Chạy migrations
docker compose exec web rails db:migrate

# Import dữ liệu mẫu
docker compose exec web rails db:seed

# Hoặc import từ CSV
docker compose exec web rails runner "CsvImporterService.new('sample_data.csv').import"
```

#### Bước 5: Kiểm tra ứng dụng
```bash
# Xem logs
docker compose logs -f web

# Kiểm tra database
docker compose exec web rails console
# Trong console: Student.count
```

#### Bước 6: Truy cập ứng dụng
- **Web Interface**: http://localhost:3001
- **API Base URL**: http://localhost:3001/api/v1/
- **Health Check**: http://localhost:3001/up

### Cài đặt Local Development

#### Bước 1: Cài đặt dependencies
```bash
# Cài đặt Ruby (sử dụng rbenv)
rbenv install 3.4.5
rbenv local 3.4.5

# Cài đặt PostgreSQL
# Ubuntu/Debian:
sudo apt-get install postgresql postgresql-contrib

# macOS:
brew install postgresql
brew services start postgresql

# Cài đặt Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Bước 2: Thiết lập database
```bash
# Tạo user và database
sudo -u postgres psql
CREATE USER g_scores_user WITH PASSWORD 'password';
CREATE DATABASE g_scores_development OWNER g_scores_user;
CREATE DATABASE g_scores_test OWNER g_scores_user;
\q
```

#### Bước 3: Cài đặt gems và dependencies
```bash
# Cài đặt gems
bundle install

# Cài đặt JavaScript dependencies
bin/importmap install

# Precompile assets
rails assets:precompile
```

#### Bước 4: Chạy migrations và seed data
```bash
# Chạy migrations
rails db:migrate

# Import dữ liệu mẫu
rails db:seed

# Hoặc import từ CSV
rails runner "CsvImporterService.new('sample_data.csv').import"
```

#### Bước 5: Chạy server
```bash
# Development server
rails server

# Hoặc với binding cụ thể
rails server -b 0.0.0.0 -p 3000
```

### Troubleshooting

#### Lỗi thường gặp với Docker
```bash
# Container không start
docker compose down
docker compose up -d

# Database connection error
docker compose exec web rails db:create
docker compose exec web rails db:migrate

# Permission issues
sudo chown -R $USER:$USER .
```

#### Lỗi thường gặp với Local
```bash
# Gem installation issues
bundle install --path vendor/bundle

# Database connection
rails db:create db:migrate

# Asset compilation
rails assets:clobber
rails assets:precompile
```

### Kiểm tra cài đặt

#### Test cơ bản
```bash
# Kiểm tra Rails console
rails console
> Student.count
> exit

# Test API endpoints
curl http://localhost:3001/api/v1/reports/statistics
curl http://localhost:3001/up
```

#### Test với dữ liệu mẫu
```bash
# Tra cứu học sinh
curl "http://localhost:3001/api/v1/students/01000001"

# Xem thống kê
curl "http://localhost:3001/api/v1/reports/statistics"
```

### Deployment lên Production

#### Deploy với Fly.io (Khuyến nghị)
```bash
# Cài đặt flyctl
curl -L https://fly.io/install.sh | sh

# Login vào Fly.io
flyctl auth login

# Deploy ứng dụng
flyctl deploy

# Kiểm tra trạng thái
flyctl status

# Xem logs
flyctl logs
```

#### Deploy với Docker
```bash
# Build production image
docker build -t g-scores:latest .

# Chạy container
docker run -d \
  --name g-scores \
  -p 8080:8080 \
  -e RAILS_ENV=production \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db \
  g-scores:latest
```

#### Deploy với Heroku
```bash
# Cài đặt Heroku CLI
# Tạo app
heroku create your-app-name

# Set environment variables
heroku config:set RAILS_ENV=production
heroku config:set SECRET_KEY_BASE=your-secret-key

# Deploy
git push heroku main

# Chạy migrations
heroku run rails db:migrate
```

### Environment Variables

#### Development (.env)
```bash
DATABASE_URL=postgresql://postgres:password@localhost:5432/g_scores_development
SECRET_KEY_BASE=your-development-secret-key
RAILS_ENV=development
```

#### Production
```bash
DATABASE_URL=postgresql://user:password@host:5432/database
SECRET_KEY_BASE=your-production-secret-key
RAILS_ENV=production
G_SCORES_DATABASE_PASSWORD=your-db-password
```

## Sử dụng

### Web Interface

#### Tra cứu điểm thi
1. **Truy cập trang chủ**: http://localhost:3001
2. **Nhập số báo danh**: 8 chữ số (ví dụ: 01000001)
3. **Nhấn "Tra cứu"** hoặc Enter
4. **Xem kết quả**: Điểm các môn học, mức điểm, trung bình khối A

#### Xem thống kê
1. **Truy cập**: http://localhost:3001/reports/statistics
2. **Chọn môn học**: Click vào tên môn để xem biểu đồ
3. **Xem phân bố điểm**: 4 mức (≥8, 6-8, 4-6, <4)
4. **Tương tác**: Zoom, hover để xem chi tiết

#### Top học sinh khối A
1. **Truy cập**: http://localhost:3001/reports/top_students
2. **Xem danh sách**: Top 10 học sinh có điểm cao nhất
3. **Thông tin**: SBD, điểm Toán-Lý-Hóa, trung bình khối A

### API Usage

#### Tra cứu học sinh
```bash
# GET /api/v1/students/:sbd
curl "http://localhost:3001/api/v1/students/01000001"

# Response:
{
  "sbd": "01000001",
  "toan": 8.4,
  "ngu_van": 6.75,
  "ngoai_ngu": 8.0,
  "vat_li": 6.0,
  "hoa_hoc": 5.25,
  "sinh_hoc": 5.0,
  "lich_su": null,
  "dia_li": null,
  "gdcd": null,
  "ma_ngoai_ngu": "N1",
  "group_a_average": 6.55,
  "score_levels": {
    "toan": "Giỏi",
    "ngu_van": "Khá",
    "ngoai_ngu": "Giỏi",
    "vat_li": "Khá",
    "hoa_hoc": "Trung bình",
    "sinh_hoc": "Trung bình"
  }
}
```

#### Thống kê điểm thi
```bash
# GET /api/v1/reports/statistics
curl "http://localhost:3001/api/v1/reports/statistics"

# Response:
{
  "subjects": {
    "toan": {
      "excellent": 25,
      "good": 30,
      "average": 35,
      "poor": 10
    },
    "ngu_van": { ... }
  },
  "total_students": 100
}
```

#### Top học sinh khối A
```bash
# GET /api/v1/reports/top_students
curl "http://localhost:3001/api/v1/reports/top_students"

# Response:
[
  {
    "sbd": "01000001",
    "toan": 8.4,
    "vat_li": 6.0,
    "hoa_hoc": 5.25,
    "group_a_average": 6.55,
    "rank": 1
  },
  ...
]
```

### Số báo danh mẫu để test
- `01000001` - Học sinh có đầy đủ điểm
- `01000002` - Học sinh khối C (Sử, Địa, GDCD)
- `01000003` - Học sinh điểm cao khối A
- `01000004` - Học sinh điểm thấp
- `01000005` - Học sinh thiếu một số môn

## API

- `GET /api/v1/students/:sbd` - Thông tin học sinh
- `GET /api/v1/reports/statistics` - Thống kê điểm thi
- `GET /api/v1/reports/top_students` - Top 10 khối A

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

## Demo

### Production URL
- **Live Demo**: https://your-app-name.fly.dev/
- **API Base**: https://your-app-name.fly.dev/api/v1/

### Screenshots
- **Homepage**: Tra cứu điểm thi với form tìm kiếm
- **Student Details**: Hiển thị điểm chi tiết và mức đánh giá
- **Statistics**: Biểu đồ tương tác phân bố điểm theo môn
- **Top Students**: Danh sách top 10 học sinh khối A

## Contributing

### Development Workflow
1. Fork repository
2. Tạo feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -m 'Add new feature'`
4. Push branch: `git push origin feature/new-feature`
5. Tạo Pull Request

### Code Style
- Sử dụng RuboCop cho Ruby code
- Follow Rails conventions
- Viết tests cho features mới
- Update documentation
