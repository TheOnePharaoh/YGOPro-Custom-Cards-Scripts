--Mechquipped Hydra
function c19007843.initial_effect(c)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19007843.spcon)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c19007843.damtg)
	e2:SetOperation(c19007843.damop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCountLimit(1,19007843)
	e3:SetCondition(c19007843.poscon)
	e3:SetTarget(c19007843.destg)
	e3:SetOperation(c19007843.desop)
	c:RegisterEffect(e3)
end
function c19007843.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c19007843.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c19007843.damop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
  if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 or Duel.ChangePosition(c,POS_FACEUP_ATTACK,POS_FACEDOWN_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)>0 then
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	end
 end
function c19007843.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007843.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19007843.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c19007843.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c19007843.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19007843.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19007843.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
