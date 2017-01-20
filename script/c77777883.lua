--Benevolent Goddess of the Glade
function c77777883.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c77777883.xyzfilter,4,2)
	c:EnableReviveLimit()
  --flip
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FLIP+EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetDescription(aux.Stringid(77777883,2))
	e1:SetTarget(c77777883.rettg)
	e1:SetOperation(c77777883.retop)
	c:RegisterEffect(e1)
  --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777883,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c77777883.damcon)
	e2:SetTarget(c77777883.damtg)
	e2:SetOperation(c77777883.damop)
	c:RegisterEffect(e2)
  --set cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777883,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c77777883.cost)
	e3:SetTarget(c77777883.thtg)
	e3:SetOperation(c77777883.thop)
	c:RegisterEffect(e3)
  --attack limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetOperation(c77777883.flipop)
	c:RegisterEffect(e5)
end

function c77777883.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77777876,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77777883.xyzfilter(c)
	return c:IsSetCard(0x40c)
end

function c77777883.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777883.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c77777883.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777883.cfilter,1,nil,tp)
end
function c77777883.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c77777883.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c77777883.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER)
end
function c77777883.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777883.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777883.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c77777883.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c77777883.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777883.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777883.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
    local g2=Duel.GetMatchingGroup(c77777883.filter2,tp,0,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			local sg=g2:Select(tp,1,2,nil)
			Duel.Destroy(sg,REASON_EFFECT)
    end
  end
end


function c77777883.flipfilter(c)
	return c:IsFacedown()
end
function c77777883.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c77777883.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c77777883.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

function c77777883.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
