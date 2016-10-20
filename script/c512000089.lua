--Spike Egg
function c512000089.initial_effect(c)
	--lose lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27143874,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetOperation(c512000089.op)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetOperation(c512000089.regop)
	c:RegisterEffect(e2)
end
function c512000089.op(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	if lp>=600 then
		Duel.SetLP(1-tp,lp-600)
	else
		Duel.SetLP(1-tp,0)
	end
end
function c512000089.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(36687247,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
		e1:SetTarget(c512000089.sptg)
		e1:SetOperation(c512000089.spop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c512000089.filter(c,e,tp)
	return c:IsCode(511002441) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000089.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c512000089.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c512000089.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
