from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException

from sqlalchemy.orm import Session

from app.db.session import get_db

from app.schemas.user import (
    UserCreate,
    UserResponse
)

from app.services.user_service import (
    create_user,
    get_users,
    get_user,
    delete_user
)

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


@router.post(
    "",
    response_model=UserResponse,
    status_code=201
)
def create_user_endpoint(
    payload: UserCreate,
    db: Session = Depends(get_db)
):

    return create_user(
        db,
        payload
    )


@router.get(
    "",
    response_model=list[UserResponse]
)
def get_users_endpoint(
    db: Session = Depends(get_db)
):

    return get_users(db)


@router.get(
    "/{user_id}",
    response_model=UserResponse
)
def get_user_endpoint(
    user_id: int,
    db: Session = Depends(get_db)
):

    user = get_user(
        db,
        user_id
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return user


@router.delete(
    "/{user_id}"
)
def delete_user_endpoint(
    user_id: int,
    db: Session = Depends(get_db)
):

    user = delete_user(
        db,
        user_id
    )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return {
        "message": "User deleted"
    }