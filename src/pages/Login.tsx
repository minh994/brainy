import React from 'react';
import AuthForm from '../components/AuthForm';

const Login: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <AuthForm type="login" />
    </div>
  );
};

export default Login; 