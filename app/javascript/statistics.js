// Statistics Chart Handler
class StatisticsChart {
  constructor() {
    this.currentChart = null;
    this.statistics = null;
    this.init();
  }

  init() {
    console.log('StatisticsChart: Initializing...');
    // Get statistics data from the page
    const statisticsElement = document.getElementById('statistics-data');
    if (statisticsElement) {
      console.log('StatisticsChart: Found statistics data element');
      this.statistics = JSON.parse(statisticsElement.textContent);
      console.log('StatisticsChart: Statistics data:', this.statistics);
      this.setupEventListeners();
      this.initializeChart();
    } else {
      console.log('StatisticsChart: No statistics data element found');
    }
  }

  setupEventListeners() {
    const subjectButtons = document.querySelectorAll('.subject-btn');
    subjectButtons.forEach(btn => {
      btn.addEventListener('click', (e) => {
        const subject = e.target.dataset.subject;
        this.updateChart(subject);
        this.updateActiveButton(e.target);
      });
    });
  }

  updateActiveButton(activeButton) {
    document.querySelectorAll('.subject-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    activeButton.classList.add('active');
  }

  initializeChart() {
    if (this.statistics && Object.keys(this.statistics).length > 0) {
      const firstSubject = Object.keys(this.statistics)[0];
      this.updateChart(firstSubject);
      this.setFirstButtonActive(firstSubject);
    }
  }

  setFirstButtonActive(subject) {
    const firstButton = document.querySelector(`[data-subject="${subject}"]`);
    if (firstButton) {
      firstButton.classList.add('active');
    }
  }

  updateChart(subject) {
    console.log('StatisticsChart: Updating chart for subject:', subject);
    if (!this.statistics || !this.statistics[subject]) {
      console.log('StatisticsChart: No data for subject:', subject);
      return;
    }

    const data = this.statistics[subject];
    console.log('StatisticsChart: Data for', subject, ':', data);
    const ctx = document.getElementById('statisticsChart');
    
    if (!ctx) {
      console.log('StatisticsChart: Canvas element not found');
      return;
    }

    if (this.currentChart) {
      this.currentChart.destroy();
    }

    console.log('StatisticsChart: Creating new chart...');
    this.currentChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Xuất sắc (≥8)', 'Khá (6-8)', 'Trung bình (4-6)', 'Yếu (<4)'],
        datasets: [{
          data: data.map(d => d.count),
          backgroundColor: [
            '#28a745', // Green for excellent
            '#007bff', // Blue for good
            '#ffc107', // Yellow for average
            '#dc3545'  // Red for poor
          ],
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            text: `Thống kê môn ${subject.charAt(0).toUpperCase() + subject.slice(1).replace('_', ' ')}`,
            font: {
              size: 16,
              weight: 'bold'
            }
          },
          legend: {
            position: 'bottom',
            labels: {
              padding: 20,
              usePointStyle: true
            }
          }
        }
      }
    });
  }
}

// Form Validation Handler
class FormValidator {
  constructor() {
    this.init();
  }

  init() {
    const searchForm = document.getElementById('search-form');
    if (searchForm) {
      searchForm.addEventListener('submit', (e) => {
        this.validateSearchForm(e);
      });
    }
  }

  validateSearchForm(e) {
    const sbdInput = document.getElementById('sbd');
    const sbd = sbdInput.value.trim();

    if (!sbd) {
      e.preventDefault();
      this.showError('Vui lòng nhập số báo danh');
      return;
    }

    if (!/^\d{8}$/.test(sbd)) {
      e.preventDefault();
      this.showError('Số báo danh phải có đúng 8 chữ số');
      return;
    }
  }

  showError(message) {
    // Remove existing error messages
    const existingError = document.querySelector('.form-error');
    if (existingError) {
      existingError.remove();
    }

    // Create new error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'alert alert-danger form-error mt-2';
    errorDiv.textContent = message;

    // Insert after the form
    const form = document.getElementById('search-form');
    form.parentNode.insertBefore(errorDiv, form.nextSibling);

    // Auto remove after 5 seconds
    setTimeout(() => {
      if (errorDiv.parentNode) {
        errorDiv.remove();
      }
    }, 5000);
  }
}

// Flash Message Handler
class FlashMessageHandler {
  constructor() {
    this.init();
  }

  init() {
    const flashMessages = document.querySelectorAll('.alert');
    flashMessages.forEach(message => {
      // Auto dismiss after 5 seconds
      setTimeout(() => {
        if (message.parentNode) {
          message.remove();
        }
      }, 5000);
    });
  }
}

// Initialize all handlers when page is fully loaded
window.addEventListener('load', function() {
  console.log('Page loaded, initializing handlers...');
  console.log('Chart.js available:', typeof Chart !== 'undefined');
  
  // Initialize statistics chart if on statistics page
  if (document.getElementById('statisticsChart')) {
    console.log('Found statistics chart element, initializing...');
    // Wait a bit more to ensure everything is ready
    setTimeout(function() {
      new StatisticsChart();
    }, 500);
  }

  // Initialize form validation
  new FormValidator();

  // Initialize flash message handler
  new FlashMessageHandler();
});
