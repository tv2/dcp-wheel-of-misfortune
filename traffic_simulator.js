import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 1000 },  // Ramp up to 100 users over 10 seconds
    { duration: '10s', target: 2000 },  // Ramp up to 100 users over 10 seconds
    { duration: '10m', target: 1000 },   // Stay at 100 users for 10 minutes
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
  }
};

export default function () {
  const url = 'https://womf-incident-004-nginx.ccs.d.tv2dev.dk';

  const params = {
    headers: {
      'User-Agent': 'k6-load-test',
    },
  };

  http.get(url, params);

  // Random sleep between 1 and 3 seconds
  //sleep(Math.random() * 2 + 1);
}

//export const options = {
//  vus: 10,
//  duration: '30s',
//  cloud: {
//    // Project: Default project
//    projectID: 6452478,
//    // Test runs with the same name groups test runs together.
//    name: 'Test (20/01/2026-12:56:15)'
//  }
//};
//
//export default function() {
//  http.get('https://quickpizza.grafana.com');
//  sleep(1);
//}
