# Production Dockerfile for G-Scores
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

# Set environment variables for production
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Precompile assets during build
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expose port
EXPOSE 8080

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Starting G-Scores application..."\n\
\n\
# Run database migrations\n\
echo "Running database migrations..."\n\
RAILS_ENV=production bundle exec rails db:migrate\n\
\n\
# Start Rails server\n\
echo "Starting Rails server..."\n\
RAILS_ENV=production bundle exec rails server -b 0.0.0.0 -p 8080\n\
' > /app/start.sh && chmod +x /app/start.sh

# Start Rails server
CMD ["/app/start.sh"]