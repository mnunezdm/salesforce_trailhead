const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
module.exports = {
    ...jestConfig,
    // add any custom configurations here
    moduleNameMapper: {
        '^lightning/button$': '<rootDir>/main/test/jest-mocks/lightning/button',
        '^thunder/hammerButton$': '<rootDir>/main/test/jest-mocks/thunder/hammerButton',
    }
};