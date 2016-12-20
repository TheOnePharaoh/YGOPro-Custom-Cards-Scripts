--Hellformed Aetherial Descendant, Lilith
function c77777788.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,77777788)
	e1:SetCondition(c77777788.negcon)
	e1:SetCost(c77777788.negcost)
	e1:SetTarget(c77777788.negtg)
	e1:SetOperation(c77777788.negop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777788.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777788,2))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777788.scop)
	c:RegisterEffect(e3)
	--lvchange
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetDescription(aux.Stringid(77777788,0))
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777788.lvtg)
	e4:SetOperation(c77777788.lvop)
	c:RegisterEffect(e4)
	--destroy maintenance
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777788,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(c77777788.descon)
	e5:SetOperation(c77777788.desop)
	c:RegisterEffect(e5)
end

function c77777788.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_FIEND)or c:IsRace(RACE_SPELLCASTER)) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777788.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end

function c77777788.lvfilter(c)
	return (c:IsSetCard(0x144) or c:IsSetCard(0x3e7))and c:IsFaceup()
end
function c77777788.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777788.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c77777788.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77777788.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if  Duel.IsExistingMatchingCard(c77777788.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		local g=Duel.GetMatchingGroup(c77777788.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end
function c77777788.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function c77777788.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77777788.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingTarget(c77777788.penfilter,tp,LOCATION_SZONE,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(77777788,3)) then
		local g=Duel.SelectMatchingCard(tp,c77777788.penfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.Destroy(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_RULE) end
end
function c77777788.penfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end

function c77777788.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()and Duel.IsChainNegatable(ev)
		and re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function c77777788.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)and (c:IsSetCard(0x144)or c:IsSetCard(0x3e7))
end
function c77777788.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c77777788.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c77777788.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c77777788.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77777788.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
