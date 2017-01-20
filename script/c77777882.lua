--Forested Sprite of the Glade
function c77777882.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c77777882.xyzfilter,3,2)
	c:EnableReviveLimit()
  --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777882,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
  e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777882.cost)
	e1:SetTarget(c77777882.destg)
	e1:SetOperation(c77777882.desop)
	c:RegisterEffect(e1)
  --flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FLIP+EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCondition(c77777882.condition)
	e2:SetTarget(c77777882.drtg)
	e2:SetOperation(c77777882.drop)
	c:RegisterEffect(e2)
	--set cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777882,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c77777882.thcon)
	e3:SetTarget(c77777882.thtg)
	e3:SetOperation(c77777882.thop)
	c:RegisterEffect(e3)
  --indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c77777882.con)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
  --attack limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FLIP)
	e6:SetOperation(c77777882.flipop)
	c:RegisterEffect(e6)
end

function c77777882.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77777876,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77777882.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c77777882.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER)
end
function c77777882.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77777882.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77777882.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777882.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777882.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end



function c77777882.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777882.filter2(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c77777882.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777882.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c77777882.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77777882.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777882.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end


function c77777882.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end

function c77777882.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0))
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777882.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c77777882.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_DEFENSE)
end