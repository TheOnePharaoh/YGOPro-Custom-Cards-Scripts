--Diabound Kernel #4
function c512000041.initial_effect(c)
	c:EnableReviveLimit()
	--sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26949946,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c512000041.spcon)
	e4:SetTarget(c512000041.sptg)
	e4:SetOperation(c512000041.spop)
	c:RegisterEffect(e4)
	--gain effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(aux.bdocon)
	e6:SetTarget(c512000041.efftg)
	e6:SetOperation(c512000041.effop)
	c:RegisterEffect(e6)
end
function c512000041.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
end
function c512000041.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
end
function c512000041.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c512000041.spfilter(c,e,tp)
	return c:IsCode(512000042) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c512000041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c512000041.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c512000041.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	elseif Duel.IsPlayerCanSpecialSummon(tp) then
		local cg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(tp)
	end
end
