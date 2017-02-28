--Colossal Warrior - Jet Black
function c78219332.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c78219332.splimcon)
	e1:SetTarget(c78219332.splimit)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c78219332.descon)
	c:RegisterEffect(e2)
	--place pcard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219332,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c78219332.pencon)
	e3:SetCost(c78219332.pencost)
	e3:SetTarget(c78219332.pentg)
	e3:SetOperation(c78219332.penop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78219332,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c78219332.drcon)
	e4:SetTarget(c78219332.drtg)
	e4:SetOperation(c78219332.drop)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c78219332.discon1)
	e5:SetOperation(c78219332.disop1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)	
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetOperation(c78219332.spop)
	c:RegisterEffect(e6)
	--place card
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(78219332,2))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(c78219332.sgtg)
	e7:SetOperation(c78219332.sgop)
	c:RegisterEffect(e7)
end
function c78219332.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c78219332.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x7ad30) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c78219332.descon(e)
	return not Duel.IsEnvironment(78219322)
end
function c78219332.penfilter4(c)
    return c:IsSetCard(0x7ad30) and c:IsType(TYPE_PENDULUM)
end
function c78219332.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c78219332.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1115,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1115,2,REASON_COST)
end
function c78219332.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c78219332.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c78219332.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219332.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c78219332.drfilter(c)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c78219332.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return eg:IsExists(c78219332.drfilter,1,nil) and rc:IsSetCard(0x95)
end
function c78219332.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78219332.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c78219332.discon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetFlagEffect(78219332)~=0
	and Duel.GetAttacker():GetControler()==tp
end
function c78219332.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetCondition(c78219332.discon2)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e2:SetOperation(c78219332.disop2)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
end
function c78219332.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c78219332.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and re:GetHandler()==e:GetLabelObject() then
		Duel.NegateEffect(ev)
	end
end
function c78219332.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	local rc=re:GetHandler()
	if eg:GetCount()==1  and tg:GetSummonType()==SUMMON_TYPE_XYZ and tg:IsSetCard(0x1048) or tg:IsSetCard(0x1073)
	and rc:IsSetCard(0x95) then
		tg:RegisterFlagEffect(78219332,RESET_EVENT+0x1fe0000,0,1) 	
	end
end
function c78219332.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219332.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219332.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219332.sgop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219332.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,78219326,e,0,tp,0,0)
	end
end
