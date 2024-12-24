const express = require('express');
const User = require('../models/user.model');
const mongoose = require('mongoose');
const router = express.Router();
const bcrypt = require('bcrypt');

router.post('/signup', async (req, res) => {
    try {
        const { name, phone, email, password } = req.body;

        if (!name || !phone || !email || !password) {
            return res.status(400).json({ message: 'Name, phone, email, and password are required.' });
        }

        const existingUser = await User.findOne({ email: email });
        if (existingUser) {
            return res.status(409).json({ message: 'Email is already registered.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

  
        const newUser = new User({ name, phone, email, password: hashedPassword });
        await newUser.save();


        res.status(201).json({
            _id: newUser._id,
            name: newUser.name,
            phone: newUser.phone,
            email: newUser.email,
        });
    } catch (err) {
        console.error('Error during sign up:', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.post('/signin', async (req, res) => {
    try {
        const { email, password } = req.body;


        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required.' });
        }

       
        const user = await User.findOne({ email: email });
        if (!user) {
            return res.status(401).json({ message: 'Invalid email or password.' });
        }

 
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid email or password.' });
        }

   
        res.status(200).json({
            _id: user._id,
            name: user.name,
            phone: user.phone,
            email: user.email,
        });
    } catch (err) {
        console.error('Error during sign in:', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.get('/get/:id', async (req, res) => {
    try {
        const userId = req.params.id;

   
        if (!mongoose.Types.ObjectId.isValid(userId)) {
            return res.status(400).json({ message: 'Invalid user ID format' });
        }

        const user = await User.findById(userId);
        if (user) {
            res.status(200).json(user);
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Server error' });
    }
});


router.put('/put/:id', async (req, res) => {
    try {
        const { name, phone } = req.body;


        if (!name || !phone) {
            return res.status(400).json({ message: 'Name and phone are required.' });
        }

        const updatedUser = await User.findByIdAndUpdate(
            req.params.id,
            { name: name, phone: phone },  
            { new: true }
        ).select('-password');
        if (updatedUser) {
            res.status(200).json(updatedUser);
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Server error' });
    }
});


router.delete('/delete/:id', async (req, res) => {
    try {
        const deletedUser = await User.findByIdAndDelete(req.params.id);
        if (deletedUser) {
            res.status(200).json({ message: `User ID: ${req.params.id} deleted successfully` });
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
