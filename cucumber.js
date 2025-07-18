const config = {
  default: {
    requireModule: ['ts-node/register'],
    require: ['tests/step-definitions/**/*.ts'],
    format: [
      'progress-bar',
      'json:reports/cucumber/results.json',
      'html:reports/cucumber/report.html',
      'junit:reports/cucumber/results.xml'
    ],
    formatOptions: {
      snippetInterface: 'async-await'
    },
    publishQuiet: true,
    parallel: 2
  }
};

module.exports = config;
