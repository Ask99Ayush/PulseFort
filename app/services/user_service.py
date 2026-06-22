from sqlalchemy.orm import Session

from app.models.user import User
from app.schemas.user import UserCreate


def create_user(
    db: Session,
    payload: UserCreate
) -> User:

    user = User(
        name=payload.name,
        email=payload.email
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


def get_users(db: Session):

    return db.query(User).all()


def get_user(
    db: Session,
    user_id: int
):

    return (
        db.query(User)
        .filter(User.id == user_id)
        .first()
    )


def delete_user(
    db: Session,
    user_id: int
):

    user = (
        db.query(User)
        .filter(User.id == user_id)
        .first()
    )

    if not user:
        return None

    db.delete(user)
    db.commit()
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from fastapi import HTTPException

from app.models.user import User
from app.schemas.user import UserCreate


def create_user(
    db: Session,
    payload: UserCreate
) -> User:

    try:

        user = User(
            name=payload.name,
            email=payload.email
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        return user

    except IntegrityError:

        db.rollback()

        raise HTTPException(
            status_code=409,
            detail="Email already exists"
        )


def get_users(db: Session):

    return db.query(User).all()


def get_user(
    db: Session,
    user_id: int
):

    return (
        db.query(User)
        .filter(User.id == user_id)
        .first()
    )


def delete_user(
    db: Session,
    user_id: int
):

    user = (
        db.query(User)
        .filter(User.id == user_id)
        .first()
    )

    if not user:
        return None

    db.delete(user)
    db.commit()

    return user
    return user