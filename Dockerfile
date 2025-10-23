# Development Dockerfile for G-Scores
FROM ruby:3.4.5-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client curl libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'false' && \
    bundle config set --local without '' && \
    bundle install

# Copy application code
COPY . .

# Create a script to run the application
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Starting G-Scores application..."\n\
\n\
# Wait for database to be ready\n\
echo "Waiting for PostgreSQL database..."\n\
until pg_isready -h db -p 5432 -U postgres; do\n\
  echo "Database is unavailable - sleeping..."\n\
  sleep 2\n\
done\n\
echo "Database is ready!"\n\
\n\
# Run database migrations\n\
echo "Running database migrations..."\n\
bundle exec rails db:create db:migrate\n\
\n\
# Seed database if needed\n\
echo "Checking if database needs seeding..."\n\
if [ "$(bundle exec rails runner "puts Student.count" 2>/dev/null || echo 0)" -eq 0 ]; then\n\
  echo "Seeding database with CSV data..."\n\
  bundle exec rails db:seed\n\
else\n\
  echo "Database already has data. Student count: $(bundle exec rails runner "puts Student.count")"\n\
fi\n\
\n\
# Start Rails server\n\
echo "Starting Rails server..."\n\
bundle exec rails server -b 0.0.0.0 -p 3000\n\
' > /app/start.sh && chmod +x /app/start.sh

EXPOSE 3000

CMD ["/app/start.sh"]
