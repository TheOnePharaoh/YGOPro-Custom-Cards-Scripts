--Dream Sorcerer
function c103950034.initial_effect(c)

	--Xyz Summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	
	--Flip face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950034,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c103950034.cost)
	e1:SetTarget(c103950034.target)
	e1:SetOperation(c103950034.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end

--Flip face-down cost
function c103950034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	
	local m = e:GetHandler():GetOverlayGroup():Select(tp,1,1,nil)
	
	local tc = m:GetFirst();
	if tc:IsRace(RACE_SPELLCASTER) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	
	Duel.SendtoGrave(m,REASON_COST)
end

--Flip face-down target filter
function c103950034.tgfilter(c,tp)
	return c:IsFaceup() and c:GetControler()~=tp and c:IsLocation(LOCATION_ONFIELD)
end

--Flip face-down target
function c103950034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c103950034.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c103950034.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c103950034.tgfilter,tp,0,LOCATION_ONFIELD,1,2,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

--Flip face-down operation
function c103950034.operation(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local sct = sg:GetCount()
	
	local st = (e:GetLabel()==1)
	e:SetLabel(0)
	
	if sct <= 0 then return end
	
	local tc = sg:GetFirst()
	if c103950034.tgfilter(tc,tp) then c103950034.apply(e,tc,st) end
	
	if sct <= 1 then return end
	
	tc = sg:GetNext()
	if c103950034.tgfilter(tc,tp) then c103950034.apply(e,tc,st) end
end

--Flip face-down effect
function c103950034.apply(e,tc,st)
	local pos = POS_FACEDOWN
	if tc:IsLocation(LOCATION_MZONE) then pos = POS_FACEDOWN_DEFENSE end
	
	Duel.ChangePosition(tc,pos)
	
	if not st then return end
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	
	if pos == POS_FACEDOWN_DEFENSE then
		e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	else
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
	end
		
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e1)
end