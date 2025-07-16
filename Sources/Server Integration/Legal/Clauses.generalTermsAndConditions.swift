//
//  File.swift
//
//
//  Created by Coen coenttb on 20/06/2024.
//

import Coenttb_Legal_Documents
import Coenttb_Server_HTML
import Coenttb_Server_Router
import CoenttbMarkdown
import Dependencies
import Languages

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Clauses {
    nonisolated(unsafe)
    package static let generalTermsAndConditions: Translated<Self> = {

        @Dependency(\.coenttb.website.router) var serverRouter

        return .init { language in
            return withDependencies {
                $0.language = language
            } operation: {
                [
                    (
                        header: TranslatedString(
                            dutch: "Reikwijdte",
                            english: "Scope"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Dit zijn de Algemene Voorwaarden van coenttb (**coenttb**, **wij**, **ons**, or **onze**). coenttb is een eenmanszaak ingeschreven in het Handelsregister van de Kamer van Koophandel onder nummer 75006723.",
                                english: "These are the General Terms and Conditions of coenttb (**coenttb**, **we**, **our**, or **us**). coenttb is a sole proprietorship registered with the Trade Register of the Chamber of Commerce under number 75006723."
                            )
                        )
                        1. \#(
                            TranslatedString(
                                dutch: "Deze Algemene Voorwaarden zijn van toepassing op alle diensten die wij aan onze cliënten (**u** of **uw**) verlenen.",
                                english: "These General Terms and Conditions apply to all services we perform for our clients (**you** or **your**)."
                            )
                        )

                        1. 1. \#(
                                TranslatedString(
                                    dutch: """
                                    Verwante Personen kunnen zich beroepen op deze Algemene Voorwaarden. De bepalingen in Clausule 2.2 (enige contractpartij), 5 (Aansprakelijkheid), 7.2 (Digitale diensten) en 8 (Geschillen, toepasselijk recht en jurisdictie) van deze algemene voorwaarden gelden als onherroepelijke derdenbedingen ten behoeve van de Verwante Personen.
                                    """,
                                    english: """
                                    Related Persons may rely on these General Terms and Conditions. The stipulations made in Clause 2.2 (sole contracting party), 5 (Liability), 7.2 (Digital services) and 8 (Disputes, applicable law and jurisdiction) of these General Terms and Conditions serve as irrevocable third-party clauses (*onherroepelijke derdenbedingen*) to the benefit of the Related Persons.
                                    """
                                )
                            )

                            2. \#(
                                TranslatedString(
                                    dutch: """
                                    Verwante Personen omvatten: alle (voormalige) werknemers, ander personeel, raadslieden, aandeelhouders, partners, dochterondernemingen, gelieerde entiteiten (inclusief andere entiteiten die onder de naam coenttb opereren, en hun (voormalige) werknemers, enz.) en de stichtingen voor het beheer van derdengelden die door ons zijn ingeschakeld.
                                    """,
                                    english: """
                                    Related Persons include: any (former) employees, other staff, counsels, advisors, shareholders, partners, subsidiaries, affiliated entities (including other entities operating under the name coenttb, and their (former) employees etc.) and the foundations for the management of third-party funds (*stichtingen derdengelden*) engaged by us.
                                    """
                                )
                            )

                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Opdrachtverlening",
                            english: "Engagement"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Wij behouden ons het recht voor om geen diensten te verlenen, bijvoorbeeld op basis van belangenconflicten, cliëntcontroles en zaakacceptatiecontroles.",
                                english: "We reserve the right not to provide any services, for instance based on conflict checks, client checks and matter acceptance checks."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "coenttb is uw opdrachtnemer, ongeacht of u een overeenkomst sluit met het oog op een bepaalde Verbonden Persoon. Indien het verlenen van diensten aanleiding geeft tot enige aansprakelijkheid, kan uitsluitend coenttb (en bijvoorbeeld niet een Verbonden Persoon) aansprakelijk worden gehouden.",
                                english: "coenttb is your sole contracting party, regardless of whether you enter into an agreement with a view to a specific Related Person. If the performance of services gives rise to any liability, only coenttb (and not any Related Person) can be held liable."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "Artikelen 7:404 BW, 7:407 lid 2, en 7:409 BW zijn niet van toepassing.",
                                english: "Articles 7:404 and 7:407 paragraph 2, and 7:409 of the Dutch Civil Code do not apply."
                            )
                        )

                        4. \#(
                            TranslatedString(
                                dutch: """
                                Bij het verlenen van onze diensten zullen wij Verwante Personen inschakelen. Daarnaast kunnen wij derden inschakelen die niet verbonden zijn aan coenttb als dit wenselijk is voor onze dienstverlening (zoals adviseurs, gerechtsdeurwaarders en vertalers, gezamenlijk Gedelegeerde Partijen). Als een Gedelegeerde Partij wordt ingeschakeld, bent u gebonden aan de voorwaarden die wij met deze Gedelegeerde Partij overeenkomen. Wij zijn niet aansprakelijk voor enige schade veroorzaakt door Gedelegeerde Partijen en Gedelegeerde Partijen kunnen zich beroepen op de artikelen 5.1 t/m 5.4 (aansprakelijkheid) en 14 (Geschillen, toepasselijk recht en bevoegde rechter) van deze algemene voorwaarden.
                                """,
                                english: """
                                In providing our services we involve Related Persons. In addition, we may engage persons not related to coenttb where such engagement is desirable for the provision of our services (such as foreign counsel, bailiffs, and translators, cumulatively referred to as **Delegates**). If any Delegate is engaged, you will be bound by the terms of engagement agreed by us with such Delegate. We are not liable for any damages caused by Delegates and Delegates may rely on articles 5.1 through 5.4 (Liability) and 14 (Disputes, applicable law and jurisdiction) of these General Terms and Conditions.
                                """
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Geldige afwijkingen van de Algemene Voorwaarden",
                            english: "Permitted derogations from the General Terms and Conditions"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Afwijkingen van deze Algemene Voorwaarden zijn alleen geldig indien en voor zover deze uitdrukkelijk schriftelijk tussen de partijen zijn overeengekomen.",
                                english: "Any derogations from these General Terms and Conditions will only be valid if and insofar as expressly agreed between the parties in writing."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "coenttb is bevoegd deze Algemene Voorwaarden eenzijdig te wijzigen.",
                                english: "coenttb will be authorised to unilaterally amend these General Terms and Conditions."
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Honoraria en facturering",
                            english: "Fees and invoicing"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Tenzij anders overeengekomen, verlenen wij onze diensten op basis van bestede tijd in overeenstemming met onze uurtarieven en eventuele onkosten (zoals reiskosten en kosten van Gemandateerden). Waar van toepassing wordt BTW in rekening gebracht over honoraria en kosten. Onze uurtarieven worden jaarlijks per 1 januari herzien en zijn gebaseerd op de senioriteit van de betrokken persoon. coenttb behoudt zich het recht voor om de uurtarieven op elk moment tijdens de opdracht te verhogen met instemming van de cliënt.",
                                english: "Unless agreed otherwise, we render our services on a time spent basis in accordance with our hourly rates increased with any out-of-pockets expenses (such as travel costs and costs of Delegates). Where applicable VAT will be charged on any fees and costs. Our hourly rates are subject to review annually per 1 January and based on seniority of the person involved. coenttb reserves the right to increase the rates at any time during the assignment with consent of the client."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "Tenzij anders overeengekomen, worden onze facturen maandelijks in euro's uitgebracht en naar u verzonden, hetzij elektronisch, hetzij per gewone post. Facturen dienen binnen dertig dagen na de factuurdatum te worden betaald.",
                                english: "Unless agreed otherwise, our invoices will be issued monthly in Euro and will be sent to you either electronically or by ordinary mail. Invoices are payable within thirty days of the date of the invoice."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "Indien u de inhoudelijke juistheid van een (deel van de) factuur betwist, stelt u coenttb hiervan binnen vijf (5) werkdagen na dagtekening schriftelijk op de hoogte onder opgave van redenen. Na het verstrijken van deze termijn kan u hier geen beroep meer op doen. Indien u een deel van de factuur betwist, is hij gehouden het niet betwiste deel direct te voldoen.",
                                english: "If the client disputes the substantive accuracy of any (part of the) invoice, they must notify coenttb in writing, stating the reasons, within five (5) business days from the invoice date. After this period, the client can no longer contest the invoice. If the client disputes part of the invoice, they are obliged to immediately pay the undisputed portion."
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Aansprakelijkheid",
                            english: "Liability"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Elke aansprakelijkheid van coenttb is beperkt tot het bedrag dat door de verzekeraar wordt uitgekeerd onder de toepasselijke beroepsaansprakelijkheidsverzekering, vermeerderd met het bedrag van het eigen risico dat niet voor rekening van de verzekeraars komt onder de polisvoorwaarden.",
                                english: "Any liability of coenttb is limited to the amount paid by the insurer under the applicable professional liability insurance policy, increased by the amount of the deductible that is not for the account of the insurers under the policy terms and conditions."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "coenttb is enkel aansprakelijk voor directe schade geleden door opdrachtgever en alleen indien die schade het gevolg is van opzet of grove schuld aan de zijde van coenttb.",
                                english: "coenttb is liable only for direct damages incurred by client and only if the damage is a result of willful misconduct ('opzet') or gross negligence ('grove schuld') by coenttb."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "Indien om welke reden ook geen uitkering krachtens genoemde beroepsaansprakelijkheidsverzekering plaats vindt, is de aansprakelijkheid van coenttb beperkt tot directe schade geleden door opdrachtgever en tot hoogstens de helft van het afgesproken honorarium (in geval van een vooraf vastgesteld bedrag voor een project) of (in geval van een opdracht waarbij een uurtarief is afgesproken) de helft van het tot het moment van de ontvangst door coenttb van de aansprakelijkstelling door coenttb daadwerkelijk ontvangen honorarium voor die werkzaamheden waaruit de aansprakelijkheid voortvloeit.",
                                english: "If payment by the insurance company under such professional liability insurance does not take place for whatever reason, the liability of coenttb is limited to direct damages incurred by client and to a maximum amount equal to either (i) half of the fee agreed upon between coenttb and client for the performance by Ten Thije Boonkkamp of the assignment out of which the liability arose (in case of a fixed, pre agreed fee amount) or (ii) (in case of an assignment for which a fee amount per hour was agreed upon between Ten Thije Boonkkamp and client) half of the fee actually received by Ten Thije Boonkkamp for the performance of the assignment out of which the liability arose."
                            )
                        )

                        4. \#(
                            TranslatedString(
                                dutch: "U vrijwaart ons, Verwante Personen en Gemandateerden tegen alle aanspraken van derden die verband houden met of voortvloeien uit de verlening van diensten door ons, Verwante Personen en Gemandateerden, alsmede tegen de kosten die wij maken in verband met dergelijke aanspraken, voor zover deze aanspraken en kosten groter zijn dan of anders zijn dan die waarvoor wij aansprakelijk zouden zijn krachtens deze Algemene Voorwaarden. Voor de duidelijkheid, derden omvatten alle personen die aan u zijn gerelateerd.",
                                english: "You indemnify us, Related Persons and Delegates against any and all claims by any third party related to or in connection with the provision of services by us, Related Persons and Delegates and costs incurred by us in relation to such claims, insofar as these claims and costs are greater than or different from those to which we would be liable pursuant to these General Terms and Conditions. For the sake of clarity, third parties include any persons related to you."
                            )
                        )

                        5. \#(
                            TranslatedString(
                                dutch: "In het kader van onze opdracht kunnen wij of de door ons ingeschakelde stichtingen voor het beheer van derdengelden uw gelden of derdengelden in bewaring houden en deze gelden storten bij een bank van onze keuze onder de door die bank gestelde voorwaarden. Wij of onze stichtingen voor het beheer van derdengelden zijn niet aansprakelijk voor zover de gekozen bank haar verplichtingen niet nakomt. U bent verantwoordelijk voor de kosten die verband houden met ons of met de stichtingen die uw gelden beheren, en deze kosten kunnen worden verrekend met de gehouden gelden.",
                                english: "In the context of our engagement, we or the foundations for the management of third- party funds (stichtingen derdengelden) engaged by us may hold your funds or third- party funds for safekeeping and deposit these funds in a bank of our choice under the conditions stipulated by that bank. We or our foundations for the management of third- party funds (stichtingen derdengelden) are not liable to the extent that any chosen bank does not meet its obligations. You are responsible for costs associated with us or of the foundations holding your funds and any such costs may be set off against the funds held."
                            )
                        )

                        6. \#(
                            TranslatedString(
                                dutch: "Ten Thije Boonkkamp kan nooit aansprakelijk worden gesteld voor enige indirecte schade, gevolgschade en/of winstderving.",
                                english: "Ten Thije Boonkkamp can never be held liable for any indirect loss, consequential loss and/or loss of profit."
                            )
                        )

                        7. \#(
                            TranslatedString(
                                dutch: "Ten Thije Boonkkamp is niet aansprakelijk voor enige gebrekkige werking van apparatuur, software, gegevens en documenten, registers of andere objecten die worden gebruikt voor de uitvoering van de opdracht. De aansprakelijkheidsbeperking geldt ook indien Ten Thije Boonkkamp ten onrechte een opdracht weigert en hierdoor schade ontstaat. Alle vorderingsrechten en andere rechten van de cliënt jegens Ten Thije Boonkkamp vervallen 1 jaar na de datum waarop de cliënt op de hoogte was of had kunnen zijn van deze rechten.",
                                english: "Ten Thije Boonkkamp shall not be liable for any faulty performance of equipment, software, data and documents, registers or other objects which are used for the performance of the assignment. The limitation of liability also applies if Ten Thije Boonkkamp wrongfully refuses an assignment and loss results from this refusal. All rights of claim and other rights of the client towards Ten Thije Boonkkamp shall expire 1 year after the date when the client became or could have become aware of these."
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Rapportageverplichtingen, klantonderzoek en anti-witwaswetgeving",
                            english: "Reporting obligations, customer due diligence and anti-money laundering"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Overeenkomstig de toepasselijke wetgeving zijn wij verplicht om due diligence uit te voeren op onze cliënten en personen die aan onze cliënten zijn gerelateerd. Dit betekent onder andere dat wij verplicht zijn om bepaalde informatie en documenten over entiteiten en personen op te vragen en te bewaren. U verbindt zich ertoe ons alle informatie en documenten te verstrekken die wij opvragen om te voldoen aan onze verplichtingen krachtens de toepasselijke wetten zoals deze worden toegepast in overeenstemming met ons interne beleid en procedures.",
                                english: "Pursuant to applicable law, we are required to perform due diligence on our clients and persons related to our clients. This means, among other things, that we are required to request and hold certain information and documents on entities and persons. You undertake to provide us with any information and documents we request in order to satisfy our obligations under the applicable laws as same are applied in accordance with our internal policies and procedures."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "Overeenkomstig de toepasselijke wetgeving kunnen wij verplicht zijn om bepaalde informatie aan de overheid of belastingautoriteiten te verstrekken. Dit omvat onder andere het rapporteren van transacties aan lokale autoriteiten (inclusief de Financial Intelligence Unit) en meldingsvereisten onder Richtlijn 2018/822/EU met betrekking tot meldingsplichtige grensoverschrijdende regelingen. Raadpleeg onze website voor meer informatie over de voorwaarden van deze meldingsverplichtingen.",
                                english: "Pursuant to applicable law, we may be obliged to provide certain information to government or tax authorities. This includes having to report transactions to local authorities (including the Financial Intelligence Unit) and reporting requirements under Directive 2018/822/EU regarding reportable cross-border arrangements. Please consult our website for more information on the terms of these reporting obligations."
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Gegevens en privacy",
                            english: "Data and privacy"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "In het kader van onze opdracht zullen wij bepaalde persoonsgegevens verwerken, waaronder persoonsgegevens met betrekking tot u, uw vertegenwoordigers, werknemers, uiteindelijke begunstigden en contactpersonen, evenals andere door u aan ons verstrekte persoonsgegevens. Voor meer informatie over de manier waarop wij persoonsgegevens verwerken, verwijzen wij naar onze Privacyverklaring die beschikbaar is op onze website: ",
                                english: "In the context of our engagement, we will process certain personal data, including personal data relating to you, your representatives, employees, ultimate beneficial owners and contact persons as well as other personal data provided to us by you. For further information about the way we process personal data, we refer to our Privacy Statement available on our website: "
                            )
                        ) [privacy policy](\#(serverRouter.href(for: .privacy_statement)))

                        2. \#(
                            TranslatedString(
                                dutch: "Als u ons persoonsgegevens verstrekt van andere personen dan uzelf, verbindt u zich ertoe een kopie van onze privacyverklaring aan die personen te verstrekken.",
                                english: "If you provide personal data to us of persons other than yourself, you undertake to provide a copy of our privacy statement to those persons."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "Wij kunnen gebruik maken van digitale of andere diensten ('digitale diensten'), al dan niet aangeboden door derden, waaronder onder andere telecommunicatiediensten, softwareprogramma's, applicaties om gegevens digitaal of in de cloud te verzenden, te delen of op te slaan, internet, e-discovery, geautomatiseerde due diligence of andere applicaties waarmee gegevens kunnen worden verwerkt, doorzocht, geanalyseerd, vertaald (inclusief met behulp van kunstmatige intelligentie). Als gevolg hiervan kunnen gegevens worden verwerkt op servers of een cloud die door derden worden beheerd. Wij zullen de nodige zorgvuldigheid betrachten bij onze selectie van deze derden en dergelijke digitale diensten. Wij zijn niet aansprakelijk voor enige handelingen en/of nalatigheden van deze partijen (inclusief hun insolventie of wanbetaling) en voor enige schade of verlies die voortvloeit uit het gebruik, de onbeschikbaarheid, het verlies of het beperkte gebruik van dergelijke digitale diensten. Wij sluiten ook elke aansprakelijkheid uit die direct of indirect voortvloeit uit (a) enige beperking of verlies van de mogelijkheid om computers, het netwerk of de gegevens te gebruiken, te bedienen of te benaderen, of (b) een datalek, al dan niet als gevolg van een gegevenslek of een cyberaanval. Dit alles voor zover toegestaan onder toepasselijke wetten en regelgeving.",
                                english: "We may utilize digital or other services ('digital services'), whether or not offered by third parties which include, amongst others, telecommunication services, software programs, applications to transmit, share or store data digitally or in a cloud or otherwise, internet, e-discovery, automated due diligence or other applications which allow data to be processed, searched, analysed, translated (including with the use of artificial intelligence). As a result, data could be processed on servers or a cloud controlled by third parties. We will exercise due care in our selection of these third parties and such digital services. We are not liable for any acts and/or omissions of these parties (including their insolvency or default) and for any damage or loss ensuing from the use, unavailability, loss or restricted use of such digital services. We also exclude any liability resulting directly or indirectly from (a) any restriction or loss of the ability to use, operate or access computers, the network or the data or (b) any data breach, whether or not as a result from a data leak or a cyberattack. All if and to the extent allowed under applicable laws and regulations."
                            )
                        )

                        4. \#(
                            TranslatedString(
                                dutch: "Wij bewaren elektronische en/of papieren dossiers gedurende de periode die wordt bepaald door onze professionele praktijknormen en toepasselijke wetten. Na die periode kunnen wij dergelijke dossiers vernietigen.",
                                english: "We retain electronic and/or hardcopy files during the period that is determined by our professional practice standards and applicable laws. After that period, we may destroy such files."
                            )
                        )

                        5. \#(
                            TranslatedString(
                                dutch: "U stemt ermee in dat wij informatie, inclusief vertrouwelijke informatie, delen met Verwante Personen en Gemandateerden voor de doeleinden zoals uiteengezet in Clausule 2.4, onder voorbehoud van hun naleving van eventuele toepasselijke vertrouwelijkheidsverplichtingen.",
                                english: "You consent to us sharing information, including confidential information, with Related Persons and Delegates for the purposes set forth in Clause 2.4, subject to their observance of any applicable confidentiality obligations."
                            )
                        )
                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Geheimhouding van informatie",
                            english: "Non-disclosure of information"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Alle informatie, ongeacht de vorm of wijze van communicatie, die door coenttb aan een cliënt of door de cliënt aan coenttb wordt verstrekt en die expliciet als 'vertrouwelijk' is gemarkeerd op het moment van verstrekking, of mondeling als vertrouwelijk is aangemerkt en binnen 15 kalenderdagen schriftelijk als vertrouwelijke informatie is bevestigd, wordt beschouwd als 'Vertrouwelijke Informatie'.",
                                english: "All information, regardless of the form or mode of communication, disclosed by coenttb to a client or by the client to coenttb and explicitly marked as 'confidential' at the time of disclosure, or identified as confidential orally and confirmed in writing within 15 calendar days, is considered 'Confidential Information'."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "Beide partijen verbinden zich hierbij voor een periode van 5 jaar na ontvangst van de Vertrouwelijke Informatie:",
                                english: "Both parties hereby undertake for a period of 5 years after receipt of the Confidential Information:"
                            )
                        )

                        3. 1. \#(
                                TranslatedString(
                                    dutch: "Vertrouwelijke Informatie niet anders te gebruiken dan voor het doel waarvoor deze is verstrekt;",
                                    english: "not to use Confidential Information otherwise than for the purpose for which it was disclosed;"
                                )
                            )

                           2. \#(
                                TranslatedString(
                                    dutch: "Vertrouwelijke Informatie niet te onthullen zonder voorafgaande schriftelijke toestemming van de andere partij;",
                                    english: "not to disclose Confidential Information without the prior written consent of the other party;"
                                )
                            )

                           3. \#(
                                TranslatedString(
                                    dutch: "ervoor te zorgen dat de interne verspreiding van Vertrouwelijke Informatie plaatsvindt op basis van strikte noodzaak;",
                                    english: "to ensure that internal distribution of Confidential Information takes place on a strict need-to-know basis;"
                                )
                            )

                           4. \#(
                                TranslatedString(
                                    dutch: "alle verstrekte Vertrouwelijke Informatie, inclusief alle kopieën daarvan, op verzoek terug te geven of te vernietigen en alle informatie die in een machinaal leesbare vorm is opgeslagen, voor zover praktisch mogelijk te verwijderen. Partijen mogen een kopie van ontvangen Vertrouwelijke Informatie bewaren voor zover die partij wettelijk verplicht is om dergelijke Vertrouwelijke Informatie te bewaren, archiveren of opslaan of voor het bewijs van lopende verplichtingen, mits die partij zich houdt aan de in dit document opgenomen vertrouwelijkheidsverplichtingen met betrekking tot een dergelijke kopie.",
                                    english: "to return, or destroy, on request all Confidential Information that has been disclosed to including all copies thereof and to delete all information stored in a machine-readable form to the extent practically possible. Parties may keep a copy of the received Confidential Information to the extent it is required to keep, archive, or store such Confidential Information because of compliance with applicable laws and regulations or for the proof of ongoing obligations provided that that party complies with the confidentiality obligations herein contained with respect to such copy."
                                )
                            )

                        4. \#(
                            TranslatedString(
                                dutch: "Iedere partij is verantwoordelijk voor de naleving van bovenstaande verplichtingen door zijn werknemers of derden en zal ervoor zorgen dat zij, voor zover wettelijk mogelijk, tijdens en na afloop van de uitvoering van de opdracht aan coenttb en/of na de beëindiging van de contractuele relatie met de werknemer of derde partij, daaraan gebonden blijven.",
                                english: "Each party is responsible for the fulfilment of the above obligations on the part of its employees or third parties and will ensure that they remain so obliged, as far as legally possible, during and after the end of the performance of the engagement with coenttb and/or after the termination of the contractual relationship with the employee or third party."
                            )
                        )

                        5. \#(
                            TranslatedString(
                                dutch: "Het bovenstaande geldt niet voor de openbaarmaking of het gebruik van Vertrouwelijke Informatie, indien en voor zover de ontvangende partij kan aantonen dat:",
                                english: "The above does not apply for disclosure or use of Confidential Information, if and in so far as the receiving party can show that:"
                            )
                        )

                        6. 1. \#(
                                TranslatedString(
                                    dutch: "de Vertrouwelijke Informatie openbaar is geworden of openbaar wordt op een andere wijze dan door een schending van de vertrouwelijkheidsverplichtingen van de ontvangende partij;",
                                    english: "the Confidential Information has become or becomes publicly available by means other than a breach of the recipient party's confidentiality obligations;"
                                )
                            )

                           2. \#(
                                TranslatedString(
                                    dutch: "de ontsluitende partij vervolgens de ontvangende partij informeert dat de Vertrouwelijke Informatie niet langer vertrouwelijk is;",
                                    english: "the disclosing party subsequently inform the recipient party that the Confidential Information is no longer confidential;"
                                )
                            )

                           3. \#(
                                TranslatedString(
                                    dutch: "de Vertrouwelijke Informatie aan de ontvangende partij wordt gecommuniceerd zonder enige verplichting tot vertrouwelijkheid door een derde partij die, voor zover de ontvangende partij weet, rechtmatig in het bezit daarvan is en geen verplichting tot vertrouwelijkheid jegens de client heeft;",
                                    english: "the Confidential Information is communicated to the recipient party without any obligation of confidentiality by a third party who is to the best knowledge of the recipient party in lawful possession thereof and under no obligation of confidentiality to you;"
                                )
                            )

                           4. \#(
                                TranslatedString(
                                    dutch: "de Vertrouwelijke Informatie op enig moment door de ontvangende partij volledig onafhankelijk van enige dergelijke openbaarmaking door u is ontwikkeld;",
                                    english: "the Confidential Information, at any time, was developed by the recipient party completely independently of any such disclosure by you;"
                                )
                            )

                           5. \#(
                                TranslatedString(
                                    dutch: "de Vertrouwelijke Informatie al bij de ontvangende partij bekend was vóór de openbaarmaking, of",
                                    english: "the Confidential Information was already known to the recipient party prior to disclosure, or"
                                )
                            )

                           6. \#(
                                TranslatedString(
                                    dutch: "de ontvangende partij de Vertrouwelijke Informatie moet onthullen om te voldoen aan toepasselijke wetten of regelgeving of aan een gerechtelijk of administratief bevel.",
                                    english: "the recipient party is required to disclose the Confidential Information in order to comply with applicable laws or regulations or with a court or administrative order."
                                )
                            )

                        7. \#(
                            TranslatedString(
                                dutch: "de ontvangende partij zal dezelfde zorgvuldigheid toepassen met betrekking tot de Vertrouwelijke Informatie die binnen het kader van de uitvoering van de opdracht wordt verstrekt als met zijn eigen vertrouwelijke en/of eigendomsinformatie, maar in geen geval minder dan redelijke zorgvuldigheid.",
                                english: "the recipient party will apply the same degree of care with regard to the Confidential Information disclosed within the scope of the performance of the engagement as with its own confidential and/or proprietary information, but in no case less than reasonable care."
                            )
                        )

                        8. \#(
                            TranslatedString(
                                dutch: "de ontvangende partij moet de ontsluitende partij onmiddellijk schriftelijk op de hoogte stellen van elke ongeoorloofde openbaarmaking, verduistering of misbruik van Vertrouwelijke Informatie nadat hij zich bewust wordt van een dergelijke ongeoorloofde openbaarmaking, verduistering of misbruik.",
                                english: "the recipient party must promptly notify the disclosing party by written notice of any unauthorised disclosure, misappropriation, or misuse of Confidential Information after it becomes aware of such unauthorised disclosure, misappropriation, or misuse."
                            )
                        )

                        9. \#(
                            TranslatedString(
                                dutch: "Indien de ontvangende partij zich ervan bewust wordt dat hij verplicht zal zijn, of waarschijnlijk verplicht zal zijn, om Vertrouwelijke Informatie te onthullen om te voldoen aan toepasselijke wetten of regelgeving of aan een gerechtelijk of administratief bevel, moet hij, voor zover hij wettelijk in staat is dit te doen, voorafgaand aan een dergelijke openbaarmaking:",
                                english: "If the recipient party becomes aware that it will be required, or is likely to be required, to disclose Confidential Information in order to comply with applicable laws or regulations or with a court or administrative order it must, to the extent it is lawfully able to do so, prior to any such disclosure:"
                            )
                        )

                        10. 1. \#(
                                TranslatedString(
                                    dutch: "de ontsluitende partij op de hoogte stellen, en",
                                    english: "notify the disclosing party, and"
                                )
                            )

                            2. \#(
                                TranslatedString(
                                    dutch: "voldoen aan de redelijke instructies van de ontsluitende partij om de vertrouwelijkheid van de informatie te beschermen.",
                                    english: "comply with the disclosing party's reasonable instructions to protect the confidentiality of the information."
                                )
                            )

                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Intellectuele eigendomsrechten",
                            english: "Intellectual property rights"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "Alle resultaten van de opdracht worden eigendom van coenttb. Indien dit niet automatisch het geval is, verplicht u zich ertoe om alle resultaten van de opdracht aan coenttb over te dragen, en draagt u deze bij deze, indien toepasselijk, over. Onder resultaten van de opdracht worden verstaan alle rechten op resultaten, waaronder, maar niet beperkt tot eigendomsrechten, auteursrechten, merkenrechten, handelsnaamrechten, en databankrechten.",
                                english: "All results of the assignment shall become the property of coenttb. If this does not occur automatically, you are obligated to transfer all results of the assignment to coenttb, and hereby transfer such results where applicable. The results of the assignment include all rights to the results, including, but not limited to, ownership rights, copyright, trademark rights, trade name rights, and database rights."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "U mag de resultaten van de opdracht, zoals rapporten, adviezen, concepten, contracten en memo’s, uitsluitend gebruiken voor de doeleinden van de opdracht. Deze resultaten mogen niet zonder voorafgaande schriftelijke toestemming van coenttb worden verveelvoudigd, openbaar gemaakt of ter kennis van derden worden gebracht.",
                                english: "You may use the results of the assignment, such as reports, advice, concepts, contracts, and memos, solely for the purposes of the assignment. These results may not be reproduced, disclosed, or brought to the attention of third parties without the prior written consent of coenttb."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "coenttb behoudt zich het recht voor om de door de uitvoering van de werkzaamheden opgedane kennis voor andere doeleinden te gebruiken, mits hierbij niet uw vertrouwelijke informatie ter kennis van derden wordt gebracht. U verleent hierbij aan coenttb een eeuwigdurende, wereldwijde, royaltyvrije licentie om dergelijke kennis te gebruiken, voor zover dit geen inbreuk maakt op uw vertrouwelijke informatie of uw intellectuele eigendomsrechten.",
                                english: "coenttb reserves the right to use the knowledge gained from the execution of the work for other purposes, provided that your confidential information is not disclosed to third parties. You hereby grant coenttb a perpetual, worldwide, royalty-free license to use such knowledge, provided that this does not infringe upon your confidential information or your intellectual property rights."
                            )
                        )

                        4. \#(
                            TranslatedString(
                                dutch: "U garandeert dat geen rechten van derden zich verzetten tegen de beschikbaarstelling van documenten of andere materialen aan coenttb met het doel deze te gebruiken of te bewerken ten behoeve van de opdracht. U vrijwaart coenttb tegen elke actie die is gebaseerd op de bewering dat de beschikbaarstelling, het gebruik of de bewerking van dergelijke documenten of materialen inbreuk maakt op enig recht van derden.",
                                english: "You guarantee that no third-party rights prevent the provision of documents or other materials to coenttb for the purpose of use or modification in connection with the assignment. You indemnify coenttb against any action based on the claim that the provision, use, or modification of such documents or materials infringes any third-party rights."
                            )
                        )

                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Marketing",
                            english: "Marketing"
                        ).description,
                        content: CoenttbHTML.Paragraph {
                            TranslatedString(
                                dutch: "coenttb mag de naam en het logo van opdrachtgever gebruiken met een korte omschrijving van de dienstverlening van coenttb in algemene bewoordingen voor marketing doeleinden van coenttb.",
                                english: "coenttb may use the name and logo of the client with a brief description of the services provided by coenttb in general terms for coenttb’s marketing purposes."
                            )
                        }
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Beëindiging van de opdracht",
                            english: "Termination of the engagement"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "U kunt onze opdracht te allen tijde beëindigen door schriftelijke kennisgeving. Wij kunnen de opdracht beëindigen door schriftelijke kennisgeving met inachtneming van een opzegtermijn.",
                                english: "You may terminate our engagement at any time by giving written notice. We may terminate the engagement by written notice taking into account a notice period."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "In geval van beëindiging van onze opdracht bent u de honoraria verschuldigd voor het door ons verrichte werk, inclusief het werk dat nodig is om de zaak over te dragen aan u of een derde partij.",
                                english: "In case of termination of our engagement you owe the fees for the work carried out by us, including the work required to transfer the matter to you or a third party."
                            )
                        )

                        3. \#(
                            TranslatedString(
                                dutch: "Wanneer u in verzuim bent met nakoming van enige voor u uit de overeenkomst voortvloeiende verplichting, mogen wij de opdracht met onmiddellijke ingang opschorten.",
                                english: "If you fail to fulfill any obligation arising from the agreement, we may suspend the assignment with immediate effect."
                            )
                        )

                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Taal",
                            english: "Language"
                        ).description,
                        content: CoenttbHTML.Paragraph {
                            TranslatedString(
                                dutch: "Deze Algemene Voorwaarden zijn in de Nederlandse en Engelse taal gesteld. Ingeval van geschil over inhoud of strekking van deze Algemene Voorwaarden, zal de Nederlandse tekst bindend zijn.",
                                english: "These General Terms and Conditions are available in the Dutch and English language. In the case of any discrepancy or inconsistencies as to the contents and purport of these conditions, the Dutch text shall prevail."
                            )
                        }
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Overdracht of contractovername",
                            english: "Novation"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "U stemt onherroepelijk in met, gaat akkoord met, en werkt mee aan een toekomstige overdracht van uw rechtsverhouding (alle rechten en plichten) tot coenttb aan een door coenttb beheerste rechtspersoon onder Nederlands recht. De verkrijgende rechtspersoon zal vanaf de ingangsdatum van de overdracht alle rechten en verplichtingen van coenttb onder deze overeenkomst overnemen.",
                                english: "You irrevocably consent to, agree with, and cooperate with a future transfer of your legal relationship (all rights and obligations) (*novation*) with coenttb to a legal entity governed by Dutch law and controlled by coenttb. From the effective date of the transfer, the acquiring legal entity shall assume all rights and obligations of coenttb under this agreement."
                            )
                        )

                        2. \#(
                            TranslatedString(
                                dutch: "coenttb zal u ten minste 30 dagen van tevoren schriftelijk op de hoogte stellen van een overdracht van uw rechtsverhouding voordat deze van kracht wordt.",
                                english: "coenttb will notify you in writing at least 30 days prior to any such assignment, transfer, or novation taking effect."
                            )
                        )

                        """#}
                    ),
                    (
                        header: TranslatedString(
                            dutch: "Geschillen, toepasselijk recht en bevoegde rechter",
                            english: "Disputes, applicable law and jurisdiction"
                        ).description,
                        content: HTMLMarkdown {#"""
                        1. \#(
                            TranslatedString(
                                dutch: "De relatie tussen u en ons wordt beheerst door het recht van Nederland. Dit omvat alle relaties van zowel contractuele als niet-contractuele aard.",
                                english: "The relationship between you and us is governed by the laws of the Netherlands. This includes all relationships of both contractual and non-contractual origin."
                            )
                        )

                        2. \#(
                            TranslatedString.jurisdiction_clause(
                                topic: .init(
                                    dutch: "enige overeenkomsten en/of diensten waarop deze Algemene Voorwaarden van toepassing zijn",
                                    english: "any agreements and/or services to which these General Terms and Conditions apply"
                                )
                            )
                        )

                        """#}
                    )
                ]
            }

        }
    }()
}
