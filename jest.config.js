const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
module.exports = {
    ...jestConfig,
    // add any custom configurations here
    moduleNameMapper: {
        '^lightning/button$': '<rootDir>/test/jest-mocks/lightning/button',
        '^thunder/hammerButton$': '<rootDir>/test/jest-mocks/thunder/hammerButton',
        '^c/displayPanel$': '<rootDir>/test/jest-mocks/c/displayPanel',
    }
};