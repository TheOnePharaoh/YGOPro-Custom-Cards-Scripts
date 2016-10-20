--Netherworld Gate
function c103950035.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950035,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c103950035.condition)
	e1:SetCost(c103950035.cost)
	e1:SetTarget(c103950035.target)
	e1:SetOperation(c103950035.operation)
	c:RegisterEffect(e1)
end

--Activation condition
function c103950035.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,103950035)==0
end

--Activation cost
function c103950035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,103950035,RESET_PHASE+PHASE_END,0,1)
end

--Target
function c103950035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	
	local b = Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler())
	local opt=0
	
	if b then
		opt=Duel.SelectOption(tp,aux.Stringid(103950035,1),aux.Stringid(103950035,2),aux.Stringid(103950035,3))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(103950035,2))+1
	end
	
	e:SetLabel(opt)
end

--Special Summon filter
function c103950035.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--Operation
function c103950035.operation(e,tp,eg,ep,ev,re,r,rp)

	local opt=e:GetLabel()

	if opt==0 or opt==2 then
	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1 = Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g1:GetCount()~=0 then 
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			
			local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
			local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
			local seq=-1
			local tc=g2:GetFirst()
			local spcard=nil
			while tc do
				if tc:GetSequence()>seq then 
					seq=tc:GetSequence()
					spcard=tc
				end
				tc=g2:GetNext()
			end
			if seq==-1 then
				Duel.ConfirmDecktop(tp,dcount)
				Duel.ShuffleDeck(tp)
			else
				Duel.ConfirmDecktop(tp,dcount-seq)
				Duel.DisableShuffleCheck()
				if dcount-seq==1 then
					Duel.SendtoGrave(spcard,REASON_EFFECT)
				else
					local g3 = Duel.GetDecktopGroup(tp,dcount-seq-1)
					Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
					Duel.SendtoGrave(spcard,REASON_EFFECT)
				end
			end
			
			Duel.BreakEffect()
		end
	end
	
	if (opt==1 or opt==2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103950035.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g4=Duel.SelectMatchingCard(tp,c103950035.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc = g4:GetFirst()
		
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end