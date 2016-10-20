--The Sacred Forest of the Ancient Dragon
function c70649927.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c70649927.tg)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c70649927.tg)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70649927,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c70649927.datg)
	e4:SetOperation(c70649927.daop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_DESTROY)
	e5:SetCondition(c70649927.descon)
	e5:SetOperation(c70649927.desop)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c70649927.desreptg)
	e6:SetOperation(c70649927.desrepop)
	c:RegisterEffect(e6)
end
function c70649927.tg(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c70649927.dafilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c70649927.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c70649927.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70649927.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c70649927.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c70649927.daop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c70649927.dfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xd0a214)
end
function c70649927.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c70649927.dfilter,1,nil,tp)
end
function c70649927.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c70649927.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70649927.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c70649927.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70649927.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c70649927.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c70649927.repfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_SYNCHRO) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c70649927.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c70649927.repfilter,tp,LOCATION_MZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(70649927,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c70649927.repfilter,tp,LOCATION_MZONE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c70649927.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
