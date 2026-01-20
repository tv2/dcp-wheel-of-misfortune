import http from 'k6/http';

export const options = {
  stages: [
    { duration: '2m', target: 1000 },  // Ramp up to 100 users over 10 seconds
    { duration: '10s', target: 5000 },  // Ramp up to 100 users over 10 seconds
    { duration: '10s', target: 5000 },  // Ramp up to 100 users over 10 seconds
    { duration: '1m', target: 1000 },   // Stay at 100 users for 10 minutes
    { duration: '10s', target: 0 },    // Ramp down to 0 users
  ],
  cloud: {
    // Project: Default project
    projectID: 6452478,
    // Test runs with the same name groups test runs together.
    name: 'Test (20/01/2026-12:56:15)',
    distribution: {
      distributionLabel1: { loadZone: 'amazon:de:frankfurt', percent: 100 },
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<200'], // 95% of requests should be below 200ms
  },
};

export default function () {
  const url = 'https://womf-incident-004-nginx.ccs.d.tv2dev.dk';

  const params = {
    headers: {
      'User-Agent': 'k6-load-test',
    },
  };

  http.get(url, params);

}

