--Vocaloid Hatsune Miku
function c58431894.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac405),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58431894,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c58431894.condition)
	e1:SetTarget(c58431894.target)
	e1:SetOperation(c58431894.operation)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c58431894.limcon)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58431894,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c58431894.spcon)
	e3:SetCost(c58431894.spcost)
	e3:SetTarget(c58431894.sptg)
	e3:SetOperation(c58431894.spop)
	c:RegisterEffect(e3)
end
function c58431894.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c58431894.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		if tc:IsFaceup() and not tc:IsRace(RACE_MACHINE) then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	end
end
function c58431894.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) and not tc:IsRace(RACE_MACHINE) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c58431894.limcon(e)
	return not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c58431894.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c58431894.cfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS or c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c58431894.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58431894.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c58431894.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c58431894.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c58431894.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
