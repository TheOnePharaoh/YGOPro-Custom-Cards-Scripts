--Melody - Song of Life
function c11111125.initial_effect(c)
	c:SetUniqueOnField(1,1,10000000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111125+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11111125.target)
	e1:SetOperation(c11111125.activate)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c11111125.tg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c11111125.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(11111125,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,11111125)
	e4:SetCost(c11111125.thcost)
	e4:SetTarget(c11111125.thtg)
	e4:SetOperation(c11111125.thop)
	c:RegisterEffect(e4)
end
function c11111125.filter(c,e,tp)
	return c:IsSetCard(0x0dac401) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c11111125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111125.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c11111125.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11111125.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(11111125,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c11111125.descon)
		e2:SetOperation(c11111125.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c11111125.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(11111125)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c11111125.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c11111125.tg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c11111125.disfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c11111125.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111125.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11111125.disfilter,1,1,REASON_COST+REASON_DISCARD)
end

function c11111125.addfilter(c)
	return c:IsSetCard(0x0dac401) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c11111125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111125.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11111125.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11111125.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
