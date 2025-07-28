const request = require('supertest');
const express = require('express');
const app = express();
app.use(express.json());

app.post('/api/auth/register', (req, res) => {
  const { email, password, name } = req.body;
  if (!email || !password || !name) return res.status(400).json({ error: 'Données manquantes' });
  res.status(201).json({ token: 'fake_jwt_token', user: { id: '1', email, name } });
});

describe('Auth API Tests', () => {
  test('Should register a new user', async () => {
    const response = await request(app).post('/api/auth/register').send({
      email: 'test@example.com', password: 'password123', name: 'Test User'
    });
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('token');
  });
});
