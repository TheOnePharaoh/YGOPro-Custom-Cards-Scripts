--Black Knight - Greatsword
--lua script by SGJin
function c12310722.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--Disable destroyed monster's effects(Overhead Swing)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_END)
	e1:SetOperation(c12310722.disop)
	c:RegisterEffect(e1)
	--Returns 1 monster to the top of the deck (Uppercut Attack)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310722,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12310722.tdcost)
	e2:SetTarget(c12310722.tdtg)
	e2:SetOperation(c12310722.tdop)
	c:RegisterEffect(e2)
end
function c12310722.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	if not d or c:IsStatus(STATUS_BATTLE_DESTROYED) or not d:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	d:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	d:RegisterEffect(e2)
end
function c12310722.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c12310722.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c12310722.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c12310722.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310722.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12310722.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c12310722.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
