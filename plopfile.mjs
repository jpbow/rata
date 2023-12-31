// eslint-disable-next-line import/no-anonymous-default-export
export default function (
    /** @type {import('plop').NodePlopAPI} */
    plop
) {
    plop.setGenerator('package', {
        description: 'component package',
        prompts: [
            {
                type: 'input',
                name: 'name',
                message: 'package name',
            },
        ],
        actions: [
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/src/{{properCase name}}.tsx',
                templateFile: 'plop-templates/component/src/Component.tsx.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/src/index.ts',
                templateFile: 'plop-templates/component/src/index.ts.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/tests/.eslintrc.yml',
                templateFile: 'plop-templates/component/tests/.eslintrc.yml.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/tests/{{properCase name}}.test.tsx',
                templateFile: 'plop-templates/component/tests/Component.test.tsx.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/LICENSE.md',
                templateFile: 'plop-templates/component/LICENSE.md.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/package.json',
                templateFile: 'plop-templates/component/package.json.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/README.md',
                templateFile: 'plop-templates/component/README.md.hbs',
            },
            {
                type: 'add',
                path: 'packages/{{dashCase name}}/tsconfig.json',
                templateFile: 'plop-templates/component/tsconfig.json.hbs',
            },
            {
                path: 'packages/core/src/tailwind.ts',
                pattern: /(\/\/ COMPONENT STYLE INCLUDES)/g,
                template: "'./node_modules/@rata/{{dashCase name}}/**/*.js'\n$1",
                type: 'modify',
            },
            {
                type: 'add',
                path: 'storybook/stories/{{dashCase name}}/{{properCase name}}.stories.tsx',
                templateFile: 'plop-templates/storybook/Component.stories.tsx.hbs',
            },
        ],
    })
}
