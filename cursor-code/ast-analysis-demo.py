# Python example for AST analysis demonstration

"""
A complex Python file to test the enhanced AST fitness analysis
with various language-specific patterns and complexity markers.
"""

import asyncio
import logging
from typing import Dict, List, Optional, Union, Any
from dataclasses import dataclass
from abc import ABC, abstractmethod
from contextlib import asynccontextmanager

# Type definitions for complexity analysis
@dataclass
class UserData:
    """User data structure with type hints."""
    id: int
    name: str
    email: str
    role: str
    permissions: List[str]
    is_active: bool = True
    metadata: Optional[Dict[str, Any]] = None

# Abstract base class
class UserRepositoryInterface(ABC):
    """Abstract interface for user repository."""
    
    @abstractmethod
    async def get_user(self, user_id: int) -> Optional[UserData]:
        """Get user by ID."""
        pass
    
    @abstractmethod
    async def save_user(self, user: UserData) -> bool:
        """Save user data."""
        pass

# Complex class with multiple methods and branching logic
class UserManager:
    """User management service with complex logic."""
    
    def __init__(self, repository: UserRepositoryInterface):
        self.repository = repository
        self.logger = logging.getLogger(__name__)
        self._cache: Dict[int, UserData] = {}
    
    async def get_user_with_permissions(self, user_id: int) -> Optional[UserData]:
        """Get user with calculated permissions based on role."""
        try:
            # Check cache first
            if user_id in self._cache:
                return self._cache[user_id]
            
            # Fetch from repository
            user = await self.repository.get_user(user_id)
            
            if user is None:
                self.logger.warning(f"User {user_id} not found")
                return None
            
            # Complex conditional logic for permissions
            if user.role == 'admin':
                user.permissions = ['read', 'write', 'delete', 'manage']
            elif user.role == 'editor':
                user.permissions = ['read', 'write']
            elif user.role == 'viewer':
                user.permissions = ['read']
            else:
                self.logger.error(f"Unknown role: {user.role}")
                user.permissions = []
            
            # Cache and return
            self._cache[user_id] = user
            return user
            
        except Exception as e:
            self.logger.error(f"Error fetching user {user_id}: {e}")
            return None
    
    def validate_user_action(self, user: UserData, action: str) -> bool:
        """Validate if user can perform action with complex conditions."""
        # Multiple conditional checks
        if not user or not user.is_active:
            return False
        
        if action not in user.permissions:
            return False
        
        # Complex nested conditions
        if action in ['delete', 'manage']:
            return (
                user.role == 'admin' and
                user.metadata is not None and
                user.metadata.get('admin_verified', False) and
                len(user.permissions) >= 3
            )
        elif action == 'write':
            return user.role in ['admin', 'editor'] and user.is_active
        elif action == 'read':
            return user.is_active
        else:
            return False
    
    async def bulk_update_users(self, user_updates: List[Dict[str, Any]]) -> Dict[str, Union[bool, str]]:
        """Bulk update users with complex error handling."""
        results = {}
        
        for update in user_updates:
            user_id = update.get('id')
            
            try:
                # Complex validation logic
                if not user_id or not isinstance(user_id, int):
                    results[str(user_id)] = "Invalid user ID"
                    continue
                
                user = await self.get_user_with_permissions(user_id)
                
                if user is None:
                    results[str(user_id)] = "User not found"
                    continue
                
                # Update user data with validation
                for field, value in update.items():
                    if field == 'role' and value not in ['admin', 'editor', 'viewer']:
                        results[str(user_id)] = f"Invalid role: {value}"
                        break
                    elif field == 'email' and '@' not in str(value):
                        results[str(user_id)] = "Invalid email format"
                        break
                    elif field in ['name', 'email', 'role']:
                        setattr(user, field, value)
                else:
                    # Save user if all validations passed
                    success = await self.repository.save_user(user)
                    results[str(user_id)] = success
                    
                    # Update cache
                    if success:
                        self._cache[user_id] = user
                
            except Exception as e:
                self.logger.error(f"Error updating user {user_id}: {e}")
                results[str(user_id)] = f"Update failed: {str(e)}"
        
        return results

# Async context manager for complex resource management
@asynccontextmanager
async def user_session(manager: UserManager, user_id: int):
    """Async context manager for user sessions."""
    user = await manager.get_user_with_permissions(user_id)
    
    if user is None:
        raise ValueError(f"User {user_id} not found")
    
    logging.info(f"Starting session for user {user.name}")
    
    try:
        yield user
    finally:
        logging.info(f"Ending session for user {user.name}")
        # Cleanup logic could go here

# Function with multiple complexity patterns
def analyze_user_patterns(users: List[UserData]) -> Dict[str, Any]:
    """Analyze user patterns with complex logic."""
    analysis = {
        'total_users': len(users),
        'active_users': 0,
        'role_distribution': {},
        'permission_analysis': {},
        'risk_users': []
    }
    
    # Complex iteration with multiple conditions
    for user in users:
        # Count active users
        if user.is_active:
            analysis['active_users'] += 1
        
        # Role distribution analysis
        if user.role in analysis['role_distribution']:
            analysis['role_distribution'][user.role] += 1
        else:
            analysis['role_distribution'][user.role] = 1
        
        # Permission analysis
        perm_count = len(user.permissions) if user.permissions else 0
        
        if perm_count in analysis['permission_analysis']:
            analysis['permission_analysis'][perm_count] += 1
        else:
            analysis['permission_analysis'][perm_count] = 1
        
        # Risk analysis with complex conditions
        is_risk_user = (
            user.role == 'admin' and
            perm_count > 3 and
            (user.metadata is None or not user.metadata.get('verified', False))
        )
        
        if is_risk_user:
            analysis['risk_users'].append({
                'id': user.id,
                'name': user.name,
                'reason': 'Unverified admin with high permissions'
            })
    
    return analysis

# Main execution with error handling
async def main():
    """Main function with comprehensive error handling."""
    try:
        # This would normally be injected
        repository = None  # UserRepository()
        manager = UserManager(repository)
        
        # Example usage with complex control flow
        test_users = [
            UserData(1, "Alice", "alice@example.com", "admin", []),
            UserData(2, "Bob", "bob@example.com", "editor", []),
            UserData(3, "Charlie", "charlie@example.com", "viewer", [])
        ]
        
        # Process users with various complexity patterns
        for user in test_users:
            try:
                # Async context manager usage
                async with user_session(manager, user.id) as session_user:
                    if manager.validate_user_action(session_user, 'read'):
                        print(f"User {session_user.name} can read")
                    else:
                        print(f"User {session_user.name} cannot read")
                        
            except ValueError as e:
                logging.warning(f"Session error: {e}")
            except Exception as e:
                logging.error(f"Unexpected error: {e}")
        
        # Analyze patterns
        analysis = analyze_user_patterns(test_users)
        print(f"User analysis: {analysis}")
        
    except Exception as e:
        logging.critical(f"Critical error in main: {e}")
        raise

# Module-level execution
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(main())