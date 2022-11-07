FROM python:3.6

# RUN pip install raven celery==4.2.1 passlib[bcrypt] tenacity requests==2.24.0 "fastapi>=0.7.1" emails pyjwt email_validator jinja2 psycopg2-binary alembic SQLAlchemy
# For development, Jupyter remote kernel, Hydrogen
# Using inside the container:
# jupyter notebook --ip=0.0.0.0 --allow-root
ARG env=prod
RUN bash -c "if [ $env == 'dev' ] ; then pip install jupyter ; fi"
EXPOSE 8888

ENV C_FORCE_ROOT=1

COPY ./app /app
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

ENV PYTHONPATH=/app

COPY ./app/worker-start.sh /worker-start.sh

RUN chmod +x /worker-start.sh
RUN pip install -r ./requirements.txt
CMD ["bash", "/worker-start.sh"]
