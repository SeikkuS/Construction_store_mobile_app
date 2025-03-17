const express = require('express');
const stripe = require('stripe')('sk_test_51R3bYqFLhHIosR3sIQuQ7NnM7VexM8USwJ9zaHaSuHm1Va79n2Pi0AAK4lccHMDl7zeGYmATDzcwLQh37UdVLDe100BzvYY975'); // Replace with your secret key
const app = express();
app.use(express.json());

app.post('/create-payment-intent', async (req, res) => {
    console.log('Received request to create payment intent');
    const { amount } = req.body;
    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount * 100, // Convert to cents
        currency: 'usd', // Adjust currency as needed
      });
      console.log('Payment intent created:', paymentIntent.id);
      res.send({ clientSecret: paymentIntent.client_secret });
    } catch (error) {
      console.error('Error creating payment intent:', error);
      res.status(500).send({ error: error.message });
    }
  });

app.listen(3000, () => console.log('Server running on port 3000'));