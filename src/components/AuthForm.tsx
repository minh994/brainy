import React, { useState } from 'react';
import { Link } from 'react-router-dom';

interface AuthFormProps {
  type: 'login' | 'signup';
}

const AuthForm: React.FC<AuthFormProps> = ({ type }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Implement authentication logic
  };

  return (
    <div className="w-full max-w-md p-8 bg-white rounded-lg shadow-md">
      <div className="flex items-center mb-8">
        <div className="w-10 h-10 flex items-center justify-center">
          <div className="w-8 h-8 bg-blue-600 rounded-full"></div>
          <div className="w-8 h-8 bg-blue-300 rounded-full -ml-4"></div>
        </div>
        <h2 className="text-2xl font-bold ml-2">
          {type === 'login' ? 'Log in' : 'Sign Up'}
        </h2>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Email Address
          </label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
            required
          />
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            Password
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
            required
          />
        </div>

        {type === 'signup' && (
          <div>
            <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700">
              Confirm Password
            </label>
            <input
              type="password"
              id="confirmPassword"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md"
              required
            />
          </div>
        )}

        <button
          type="submit"
          className="w-full py-2 px-4 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          {type === 'login' ? 'Log In' : 'Sign Up'}
        </button>

        <div className="flex items-center justify-center space-x-4">
          <hr className="w-full border-gray-300" />
          <span className="text-gray-500">or</span>
          <hr className="w-full border-gray-300" />
        </div>

        <div className="flex space-x-4">
          <button
            type="button"
            className="flex-1 py-2 px-4 border border-gray-300 rounded-md flex items-center justify-center"
          >
            <img src="/google-icon.svg" alt="Google" className="w-5 h-5 mr-2" />
          </button>
          <button
            type="button"
            className="flex-1 py-2 px-4 border border-gray-300 rounded-md flex items-center justify-center"
          >
            <img src="/facebook-icon.svg" alt="Facebook" className="w-5 h-5 mr-2" />
          </button>
        </div>

        <p className="text-center text-sm text-gray-600">
          {type === 'login' ? (
            <>
              Don't have an account?{' '}
              <Link to="/signup" className="text-blue-600 hover:underline">
                Sign Up
              </Link>
            </>
          ) : (
            <>
              Already have an account?{' '}
              <Link to="/login" className="text-blue-600 hover:underline">
                Login
              </Link>
            </>
          )}
        </p>
      </form>
    </div>
  );
};

export default AuthForm; 