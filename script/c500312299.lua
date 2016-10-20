--Clear Mail Card
function c500312299.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c500312299.condition)
	e2:SetTarget(c500312299.target)
	e2:SetOperation(c500312299.activate)
	c:RegisterEffect(e2)
	--to defense
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500312299,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c500312299.postg)
	e3:SetOperation(c500312299.posop)
	c:RegisterEffect(e3)
	--avoid battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c500312299.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c500312299.splimit)
	e5:SetCondition(c500312299.splimcon)
	c:RegisterEffect(e5)
end
function c500312299.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc81) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c500312299.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500312299.filter,1,nil,tp)
end
function c500312299.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c500312299.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c500312299.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c500312299.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c500312299.tg(e,c)
	return c:IsSetCard(0xc81)
end
function c500312299.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xc81) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500312299.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
