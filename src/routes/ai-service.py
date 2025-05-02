from enum import Enum
from typing import Optional
import os
import json
import random
from pydantic import BaseModel
import openai
import json
from dotenv import load_dotenv, find_dotenv
from collections import deque
import asyncio
import aiohttp
# src/routes/ai_service.py


_ = load_dotenv(find_dotenv())

client = openai.Client()


async def consultar_diagnostico(patient_id):
    """Consult patient diagnostic information"""
    # Get analysis data using the shared service
    analyses = await get_patient_analysis_data(patient_id)
    print(f"Analyses: {analyses}")
    # Process the analyses as needed
    return analyses


async def get_patient_analysis_data(patient_id, **kwargs):
    """Make an actual API call to your FastAPI endpoint"""
    print(f"Calling API for patient {patient_id}")
    
    async with aiohttp.ClientSession() as session:
        # Adjust the URL to match your actual API endpoint
        url = f"http://localhost:8080/api/ai/patient/{patient_id}/analyses"
        
        try:
            print(f"Sending request to {url}")
            async with session.get(url) as response:
                if response.status == 200:
                    result = await response.json()
                    print(f"API response received with status 200")
                    return result
                else:
                    error_text = await response.text()
                    print(f"API error ({response.status}): {error_text}")
                    return [{"error": f"API call failed with status {response.status}", "details": error_text}]
        except Exception as e:
            print(f"Exception during API call: {str(e)}")
            return [{"error": f"Exception during API call: {str(e)}"}]


tools = [
    {
        "type": "function",
        "function": {
            "name": "consultar_diagnostico",
            "description": "Obtem o diagnóstico do paciente pelo seu id",
            "parameters": {
                "type": "object",
                "properties": {
                    "patient_id": {
                        "type": "integer",
                        "description": "O ID do paciente. Ex. 86",
                    },
                },
                "required": ["patient_id"]
            },
        },            
    }
]

funcoes_disponiveis = {
    "consultar_diagnostico": consultar_diagnostico
}


def ask_ai():
    print("Assistant: Welcome to your assistant. \n")

    mensagens = [{
        "role": "user",
        "content": input("User: ")
    }]

    resposta = client.chat.completions.create(
        model="gpt-3.5-turbo-0125",
        messages=mensagens,
        tools=tools,
        tool_choice="auto"
    )    

    mensagem_resp = resposta.choices[0].message
    tool_call = mensagem_resp.tool_calls[0]
    function_name = tool_call.function.name
    function_to_call = funcoes_disponiveis[function_name]
    function_args = json.loads(tool_call.function.arguments)
    
    function_response = asyncio.run(function_to_call(
        patient_id=function_args.get("patient_id", 86)
    ))

    # Adiciona a requisição do assistente
    mensagem_resp = resposta.choices[0].message.tool_calls
    call_id = mensagem_resp[0].id
    function_name = mensagem_resp[0].function.name
    args = mensagem_resp[0].function.arguments
    mensagens.append({
        "role": "assistant",
        "tool_calls": [
        {
            "id": call_id,
            "type": "function",
            "function": {
            "name": function_name,
            "arguments": args
            }
        }
        ]
    })

    mensagem_resp = resposta.choices[0].message
    tool_call = mensagem_resp.tool_calls[0]
    function_name = tool_call.function.name
    function_to_call = funcoes_disponiveis[function_name]
    function_args = json.loads(tool_call.function.arguments)
    function_response = asyncio.run(function_to_call(
        patient_id=function_args.get("patient_id")
    ))

    # executa todas as chamadas às funções
    for tool_call in mensagem_resp.tool_calls:
        function_name = tool_call.function.name
        function_to_call = funcoes_disponiveis[function_name]
        function_args = json.loads(tool_call.function.arguments)
        function_response = asyncio.run(function_to_call(
            patient_id=function_args.get("patient_id")
        ))
        mensagens.append({
            "tool_call_id": tool_call.id,
            "role": "tool",
            "name": function_name,
            "content": str(function_response),
        })

    # Realiza a segunda chamada
    segunda_resposta = client.chat.completions.create(
        model="gpt-3.5-turbo-0125",
        messages=mensagens,
    )

    resposta = segunda_resposta.choices[0].message.content
    print(f"\nAssistente: {resposta}\n" )
    return resposta



if __name__ == "__main__":
    ask_ai()    

