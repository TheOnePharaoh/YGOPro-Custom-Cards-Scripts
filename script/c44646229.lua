--M.U. Modification
function c44646229.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c44646229.target)
	e1:SetOperation(c44646229.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c44646229.eqlimit)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44646229,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c44646229.drcon)
	e3:SetTarget(c44646229.drtg)
	e3:SetOperation(c44646229.drop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(c44646229.distg)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c44646229.disop)
	c:RegisterEffect(e5)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e6:SetTarget(c44646229.distg)
	c:RegisterEffect(e6)
end
function c44646229.eqlimit(e,c)
	return c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228) and not c:IsPublic()
end
function c44646229.filter(c)
	return c:IsFaceup() and c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228) and not c:IsPublic()
end
function c44646229.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44646229.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44646229.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c44646229.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c44646229.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c44646229.drcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and r==REASON_BATTLE and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c44646229.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44646229.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c44646229.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or c:GetCardTargetCount()==0 then return false end
	local eq=ec:GetEquipTarget()
	return eq and c:GetCardTarget():IsContains(eq) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c44646229.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	local ec=e:GetHandler()
	if not ec:GetEquipTarget() or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(ec:GetEquipTarget()) then return end
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
