--Spellcatcher
function c103950039.initial_effect(c)

	--Spell Counters
	c:EnableCounterPermit(0x3001)
	c:SetCounterLimit(0x3001,3)
	
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950039,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c103950039.spcon)
	e1:SetTarget(c103950039.sptg)
	e1:SetOperation(c103950039.spop)
	c:RegisterEffect(e1)
	
	--Special Summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950039,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c103950039.addctg)
	e2:SetOperation(c103950039.addcop)
	c:RegisterEffect(e2)
	
	--Level up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetValue(c103950039.lvlvalue)
	c:RegisterEffect(e3)
	
	--Move Spell Counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103950039,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c103950039.msptgt)
	e4:SetOperation(c103950039.mspop)
	c:RegisterEffect(e4)
	
end

--Special Summon condition
function c103950039.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActiveType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

--Special Summon target
function c103950039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
						and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

--Special Summon operation
function c103950039.spop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Special Summon success target
function c103950039.addctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x3001)
end

--Special Summon success operation
function c103950039.addcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x3001,1)
	end
end

--Level up value
function c103950039.lvlvalue(e,c)
	return c:GetCounter(0x3001)
end

--Move Spell Counter filter
function c103950039.mspfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x3001,1)
end

--Move Spell Counter target
function c103950039.msptgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c103950039.mspfilter(chkc) end
	local c = e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x3001,1,REASON_EFFECT)
						and Duel.IsExistingTarget(c103950039.mspfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(103950039,3))
	Duel.SelectTarget(tp,c103950039.mspfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end

--Move Spell Counter operation
function c103950039.mspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsCanRemoveCounter(tp,0x3001,1,REASON_EFFECT) and tc:IsCanAddCounter(0x3001,1) then
		c:RemoveCounter(tp,0x3001,1,REASON_EFFECT)
		tc:AddCounter(0x3001,1)
	end
end