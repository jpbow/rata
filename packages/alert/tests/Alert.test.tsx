import { mount } from 'enzyme'
import { create, act, ReactTestRenderer } from 'react-test-renderer'
import { Alert } from '../'

it('should ', () => {
    const instance = create(<Alert></Alert>).root

    expect(instance).toBeDefined()
})
