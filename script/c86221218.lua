--Vocaloid Hagane Miku/Assault Mode
function c86221218.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c86221218.efilter)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(86221218,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c86221218.destg)
	e3:SetOperation(c86221218.desop)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86221218,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c86221218.limtg)
	e4:SetOperation(c86221218.limop)
	c:RegisterEffect(e4)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(86221218,2))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c86221218.spcon)
	e5:SetTarget(c86221218.sptg)
	e5:SetOperation(c86221218.spop)
	c:RegisterEffect(e5)
end
function c86221218.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c86221218.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and not tc:IsRace(RACE_MACHINE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c86221218.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c86221218.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c86221218.chainlm)
end
function c86221218.chainlm(e,rp,tp)
	return tp==rp
end
function c86221218.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c86221218.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c86221218.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function c86221218.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c86221218.spfilter(c,e,tp)
	return c:IsCode(5717743) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86221218.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c86221218.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c86221218.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c86221218.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c86221218.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
