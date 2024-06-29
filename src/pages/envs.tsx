import React from 'react';

interface EnvProps {
  env: Record<string, string | undefined>;
}

const EnvPage: React.FC<EnvProps> = ({ env }) => {
  return (
    <div className="prose mx-auto p-4">
      <h1>Environment Variables</h1>
      <ul>
        {Object.entries(env).map(([key, value]) => (
          <li key={key}>
            <strong>{key}:</strong> {value}
          </li>
        ))}
      </ul>
    </div>
  );
};

export const getStaticProps = async () => {
  const env = Object.keys(process.env).reduce((acc, key) => {
    acc[key] = process.env[key];
    return acc;
  }, {} as Record<string, string | undefined>);

  return {
    props: {
      env,
    },
  };
};

export default EnvPage;
