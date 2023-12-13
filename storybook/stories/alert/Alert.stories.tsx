import type { Meta, StoryObj } from '@storybook/react'
import { Alert } from '@rata/alert'
import { RocketIcon } from '@radix-ui/react-icons'

const meta: Meta<typeof Alert> = {
    title: 'Alert',
    component: Alert,
    tags: ['autodocs'],
}

export default meta
type Story = StoryObj<typeof Alert>

export const Default: Story = {
    render: () => (
        <Alert title="Heads up!" icon={<RocketIcon className="h-4 w-4" />}>
            You can add components to your app using the cli.
        </Alert>
    ),
}
