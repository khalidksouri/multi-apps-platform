import React, { ReactNode } from 'react'

interface ExampleProps {
  children: ReactNode
}

export default function ExampleUsage({ children }: ExampleProps) {
  return (
    <div className="example-usage">
      {children}
    </div>
  )
}
