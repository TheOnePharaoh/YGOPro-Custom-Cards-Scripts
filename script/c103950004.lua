--Mystical Gear
function c103950004.initial_effect(c)

	--Destroy Spell/Trap cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950004,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c103950004.target)
	e1:SetOperation(c103950004.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	
end

--Cards in Spell & Trap Card Zone filter
function c103950004.filter(c)
	return c:GetSequence()~=5 and c:IsDestructable()
end
--Target cards to destroy
function c103950004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c103950004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c103950004.filter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103950004.filter,tp,LOCATION_SZONE,0,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
--Destroy cards
function c103950004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	
	if ct <= 0 then return end
	
	--Increase Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950004,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	
	if ct <= 1 then return end
	
	--Draw 1 card
	Duel.Draw(tp,1,REASON_EFFECT)
	
	if ct <= 2 then return end
	
	--Special Summon
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c103950004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c103950004.spfilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Special Summon filter
function c103950004.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end