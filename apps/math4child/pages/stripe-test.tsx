import { NextPage } from 'next'
import StripeTestPayment from '../src/components/stripe/StripeTestPayment'

const StripeTestPage: NextPage = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <StripeTestPayment />
    </div>
  )
}

export default StripeTestPage
