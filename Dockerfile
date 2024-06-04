FROM python:3.9-slim

WORKDIR /revhire

COPY requirements.txt /revhire/
RUN pip install -r requirements.txt

COPY . /revhire/

EXPOSE 8000

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
