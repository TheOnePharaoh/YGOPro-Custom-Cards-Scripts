--ADE Tetra
function c70649933.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c70649933.splimit)
	e2:SetCondition(c70649933.splimcon)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649933,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c70649933.atkcon)
	e3:SetOperation(c70649933.atkop)
	c:RegisterEffect(e3)
	--self destruct
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c70649933.sdcon)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(70649933,1))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c70649933.reccon)
	e5:SetTarget(c70649933.rectg)
	e5:SetOperation(c70649933.recop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c70649933.spcon)
	c:RegisterEffect(e6)
end
function c70649933.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c70649933.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c70649933.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsRace(RACE_DRAGON)
end
function c70649933.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		at:RegisterEffect(e1)
	end
end
function c70649933.sdfilter(c)
	return not c:IsFaceup() or not c:IsRace(RACE_DRAGON)
end
function c70649933.sdcon(e)
	return Duel.IsExistingMatchingCard(c70649933.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c70649933.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649933.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(70649933,2),aux.Stringid(70649933,3))
	local p=(opt==0 and tp or 1-tp)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,p,1400)
end
function c70649933.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c70649933.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsSetCard(0xd0a214)
end
function c70649933.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c70649933.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end