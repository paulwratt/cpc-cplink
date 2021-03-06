// main.c - test help command demo for the CPC-CPLink board
//
// Copyright (C) 2019  Revaldinho/Shifters74
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
// 

#include <cpctelera.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <firmware.h>
#include <fifolib.h>

#define BUFFER_LENGTH 127

/* define functions below as main MUST be first function!! */
/* define functions below as main MUST be first function!! */
void send_command_to_pi(const uint8_t *command);
void read_and_display_response_from_pi(void);
uint8_t get_byte_from_pi(void);
void clear_buffer(uint8_t *response);

uint8_t response[BUFFER_LENGTH];

void main ( void ) 
{
	uint8_t index = 0;
	
	const uint8_t *command[] = 
			{"HELP\n",
			 "HELP PING\n",
			 "HELP SHUTDOWN\n",
			 "HELP TIME\n",
			 "HELP DATE\n",
			 "HELP RESET\n",
			 "HELP REBOOT\n",
			 "HELP TRON\n",
			 "HELP TROFF\n",
			 "HELP VERSION\n",
			 "HELP WIFI\n",
			 "HELP SHELLEXEC\n",
			 "HELP CALLOC\n",
			 "HELP FALLOC\n",
			 "HELP RALLOC\n",
			 "HELP SALLOC\n",
			 "HELP IALLOC\n",
			 "HELP XALLOC\n",
			 "HELP PISALLOC\n",
			 "HELP PILALLOC\n",
			 "HELP GETFILE\n",
			 "HELP PUTFILE\n",
			 "HELP GETMEMFILE\n",
			 "HELP PUTMEMFILE\n",
			 NULL};
	
	clear_buffer(response);
	
	/* set screen mode 2 */
	scr_set_mode(2);

	/* reset the fifo queue */
	fifo_reset();

	while(command[index] != NULL)
	{
		/* send the command to the pi */
		send_command_to_pi(command[index]);

		/* read the response from the pi */
		read_and_display_response_from_pi();

		printf("\r\nPress any key to continue\r");
		printf("\r\n");
		printf("\r\n");	
		
		km_wait_char();
		
		index++;
	}
}

void send_command_to_pi(const uint8_t *command)
{
	uint8_t counter = 0;
	
	/* count to the end of the null terminated string */
	while(command[counter] != 0)
	{
		counter++;
	}
	
	/* send the +++ delimiter */
	fifo_out_byte('+');
	fifo_out_byte('+');
	fifo_out_byte('+');
	
	/* send the size of the command - low byte (+3 is packet over head) */
	fifo_out_byte(counter + 3);

	/* send the size of the command - high byte */
	fifo_out_byte(0);
	
	/* send the packet_type */
	fifo_out_byte(1);
	
	/* send the command to the pi */
	for(uint8_t index = 0; index < counter; index++)
	{
		fifo_out_byte(command[ index ]);
	}
	
	/* send the --- delimiter */
	fifo_out_byte('-');
	fifo_out_byte('-');
	fifo_out_byte('-');	
}

void read_and_display_response_from_pi(void)
{
	uint8_t index = 0;
	uint8_t packet_header[6];
	
	/* read the first 6 bytes */
	while(index < 6)
	{
		packet_header[index] = get_byte_from_pi();
		index++;
	}
	
	/* if we got a packet header delimiter '+++' as expected and packet type is TextCommand (1) */
	if(packet_header[0] == '+' && packet_header[1] == '+' && packet_header[2] == '+' && packet_header[5] == 1)
	{
		uint16_t number_bytes = packet_header[3] + (packet_header[4] * 256) - 3; /* -3 as size includes packet header */
		
		index = 0;		
		/* read the message */
		while(index < number_bytes)
		{
			response[index] = get_byte_from_pi();

			if(response[index] == '\r')
			{
				printf("%s\r\n", response);
				clear_buffer(response);
				number_bytes = number_bytes - index - 1;
                index = 0;
			}
			else
			{
				index++;
			}
		}
		
		/* read the trailing delimiters '---' */
		index = 0;
		while(index < 3)
		{
			get_byte_from_pi();
			index++;
		}		
	}
	else
	{
		printf("Received malformed packet\r\n");
	}	
}

uint8_t get_byte_from_pi(void)
{
	uint8_t did_we_get_byte = 0;
	uint8_t byte_received = 0;
	
	while(did_we_get_byte == 0)
	{
		/* try and get a byte from the pi */
		did_we_get_byte = fifo_in_byte(&byte_received);

	} /* while */
	
	return(byte_received);
}

void clear_buffer(uint8_t *response)
{
	/* clear the response memory where we will build up the string response */
	for(uint8_t index = 0; index < BUFFER_LENGTH; index++)
	{
		response[index] = 0;
	}
}
