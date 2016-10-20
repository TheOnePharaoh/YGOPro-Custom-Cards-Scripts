--Toon Haku Yowane Daughter of White
function c57888884.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c57888884.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c57888884.spcon1)
	e2:SetOperation(c57888884.spop1)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c57888884.atklimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c57888884.indes)
	c:RegisterEffect(e6)
	--immune spell
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c57888884.immfilter)
	c:RegisterEffect(e7)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c57888884.damcon)
	e8:SetOperation(c57888884.damop)
	c:RegisterEffect(e8)
	--attack cost
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ATTACK_COST)
	e9:SetCost(c57888884.atcost)
	e9:SetOperation(c57888884.atop)
	c:RegisterEffect(e9)
	--self destruct
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_LEAVE_FIELD)
	e10:SetCondition(c57888884.sdescon)
	e10:SetOperation(c57888884.sdesop)
	c:RegisterEffect(e10)
	--disable
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1)
	e11:SetTarget(c57888884.distg)
	e11:SetOperation(c57888884.disop)
	c:RegisterEffect(e11)
	--special summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(57888884,0))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetCountLimit(1,57888884+EFFECT_COUNT_CODE_DUEL)
	e12:SetCondition(c57888884.spcon2)
	e12:SetTarget(c57888884.sptg)
	e12:SetOperation(c57888884.spop2)
	c:RegisterEffect(e3)
end
function c57888884.confilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888884.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c57888884.confilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.CheckReleaseGroup(tp,nil,2,nil)
end
function c57888884.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(c57888884.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c57888884.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888884.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c57888884.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888884.immfilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c57888884.indes(e,c)
	return not c:IsType(TYPE_TOON)
end
function c57888884.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:IsRelateToBattle() and eg:GetFirst()==c:GetBattleTarget()
end
function c57888884.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev,false)
end
function c57888884.atcost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c57888884.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c57888884.sdesfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c57888884.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c57888884.sdesfilter,1,nil)
end
function c57888884.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c57888884.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c57888884.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c57888884.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57888884.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c57888884.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c57888884.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
function c57888884.propfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888884.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c57888884.propfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c57888884.mehfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetCode()~=57888886
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c57888884.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c57888884.mehfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c57888884.mehfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c57888884.mehfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c57888884.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER)
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(57888884,RESET_EVENT+0x1fe0000,0,0)
		c:RegisterFlagEffect(57888884,RESET_EVENT+0x1020000,0,0)
	end
end