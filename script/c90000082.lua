--Black Flag Captain
function c90000082.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Pendulum Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90000082.tg)
	c:RegisterEffect(e1)
	--Scale Change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c90000082.condition)
	e2:SetTarget(c90000082.target)
	e2:SetOperation(c90000082.operation)
	c:RegisterEffect(e2)
	--Destroy Replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c90000082.target2)
	e3:SetValue(c90000082.value)
	e3:SetOperation(c90000082.operation2)
	c:RegisterEffect(e3)
	--Destroy Equip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_EQUIP)
	e4:SetTarget(c90000082.target3)
	e4:SetOperation(c90000082.operation3)
	c:RegisterEffect(e4)
	--ATK Up
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c90000082.target4)
	e5:SetOperation(c90000082.operation4)
	c:RegisterEffect(e5)
	--Chain Attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(c90000082.condition2)
	e6:SetOperation(c90000082.operation5)
	c:RegisterEffect(e6)
end
function c90000082.tg(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_ZOMBIE) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c90000082.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90000082.filter(c,lv)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(lv)
end
function c90000082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local scl=math.max(1,e:GetHandler():GetLeftScale()-3)
	local g=Duel.GetMatchingGroup(c90000082.filter,tp,LOCATION_MZONE,0,nil,scl)
	if e:GetHandler():GetLeftScale()>1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c90000082.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()==1 then return end
	local scl=3
	if c:GetLeftScale()==3 then scl=2 end
	if c:GetLeftScale()==2 then scl=1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-scl)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	local g=Duel.GetMatchingGroup(c90000082.filter,tp,LOCATION_MZONE,0,nil,c:GetLeftScale())
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c90000082.filter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_ZOMBIE) and not c:IsReason(REASON_REPLACE)
end
function c90000082.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000082.filter2,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(90000082,0))
end
function c90000082.value(e,c)
	return c90000082.filter2(c,e:GetHandlerPlayer())
end
function c90000082.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c90000082.filter3(c,ec)
	return c:GetEquipTarget()==ec
end
function c90000082.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000082.filter3,1,nil,e:GetHandler()) end
	local dg=eg:Filter(c90000082.filter3,nil,e:GetHandler())
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c90000082.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end
function c90000082.filter4(c,e,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsRace(RACE_ZOMBIE) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
end
function c90000082.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000082.filter4,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c90000082.filter4,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c90000082.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c90000082.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c90000082.operation5(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end