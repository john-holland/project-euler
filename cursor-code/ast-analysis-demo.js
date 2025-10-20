// JavaScript example for AST analysis demonstration

/**
 * A complex JavaScript file to test the enhanced AST fitness analysis
 * @param {string} name - The user's name
 * @returns {Promise<object>} User data object
 */
async function fetchUserData(name) {
    try {
        // Modern ES6+ syntax
        const response = await fetch(`/api/users/${name}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const userData = await response.json();
        
        // Functional programming patterns
        const processedData = userData.map(user => ({
            ...user,
            displayName: user.firstName + ' ' + user.lastName,
            isActive: user.lastLogin ? Date.now() - user.lastLogin < 86400000 : false
        })).filter(user => user.isActive);
        
        return processedData;
        
    } catch (error) {
        console.error('Error fetching user data:', error);
        return null;
    }
}

// Class definition with TypeScript-like patterns
class UserManager {
    constructor(apiClient) {
        this.apiClient = apiClient;
        this.cache = new Map();
    }
    
    // Complex branching logic
    async getUser(id) {
        // Multiple complexity patterns
        if (this.cache.has(id)) {
            return this.cache.get(id);
        }
        
        try {
            const user = await this.apiClient.get(`/users/${id}`);
            
            // Switch statement complexity
            switch (user.role) {
                case 'admin':
                    user.permissions = ['read', 'write', 'delete'];
                    break;
                case 'editor':
                    user.permissions = ['read', 'write'];
                    break;
                case 'viewer':
                default:
                    user.permissions = ['read'];
                    break;
            }
            
            // Ternary operators and logical operators
            user.canEdit = user.role === 'admin' || user.role === 'editor';
            user.displayRole = user.role ? user.role.toUpperCase() : 'UNKNOWN';
            
            this.cache.set(id, user);
            return user;
            
        } catch (error) {
            console.warn(`Failed to fetch user ${id}:`, error);
            return null;
        }
    }
    
    // Method with complex conditional logic
    validateUserPermissions(user, action) {
        const hasPermission = user.permissions && user.permissions.includes(action);
        const isValidUser = user && user.id && user.role;
        
        // Complex boolean logic
        return isValidUser && hasPermission && (
            user.isActive !== false &&
            user.account?.status === 'active' &&
            (!user.subscription || user.subscription.isValid)
        );
    }
}

// Arrow functions and modern syntax
const UserService = {
    // Async arrow function
    createUser: async (userData) => {
        const validation = UserService.validateUserData(userData);
        
        if (!validation.isValid) {
            throw new Error(`Invalid user data: ${validation.errors.join(', ')}`);
        }
        
        return await UserService.saveUser(userData);
    },
    
    // Method with nested complexity
    validateUserData: (userData) => {
        const errors = [];
        
        // Multiple if conditions
        if (!userData.email || !userData.email.includes('@')) {
            errors.push('Invalid email');
        }
        
        if (!userData.password || userData.password.length < 8) {
            errors.push('Password too short');
        }
        
        // Nested conditional with logical operators
        if (userData.age && (userData.age < 13 || userData.age > 120)) {
            errors.push('Invalid age');
        }
        
        return {
            isValid: errors.length === 0,
            errors
        };
    },
    
    saveUser: async (userData) => {
        // Promise chaining complexity
        return fetch('/api/users', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(userData)
        })
        .then(response => response.json())
        .then(data => data.user)
        .catch(error => {
            console.error('Save failed:', error);
            throw error;
        });
    }
};

// Export for module system
module.exports = { UserManager, UserService, fetchUserData };