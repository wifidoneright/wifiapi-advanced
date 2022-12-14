FROM python:3.6

# RUN pip install requests==2.24.0 pytest tenacity passlib[bcrypt] "fastapi>=0.7.1" psycopg2-binary SQLAlchemy
RUN pip install pytest
# For development, Jupyter remote kernel, Hydrogen
# Using inside the container:
# jupyter notebook --ip=0.0.0.0 --allow-root
ARG env=prod
RUN bash -c "if [ $env == 'dev' ] ; then pip install jupyter ; fi"
EXPOSE 8888

COPY ./app /app
COPY ./requirements.txt /app/requirements.txt

ENV PYTHONPATH=/app

COPY ./app/tests-start.sh /tests-start.sh

RUN chmod +x /tests-start.sh
RUN pip install -r /app/requirements.txt
# This will make the container wait, doing nothing, but alive
CMD ["bash", "-c", "while true; do sleep 1; done"]

# Afterwards you can exec a command /tests-start.sh in the live container, like:
# docker exec -it backend-tests /tests-start.sh
