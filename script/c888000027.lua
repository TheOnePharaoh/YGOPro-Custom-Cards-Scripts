--Foggy Void Slime
function c888000027.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c888000027.xyzcon)
	e1:SetOperation(c888000027.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c888000027.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c888000027.op2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000027,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c888000027.atcost)
	e4:SetTarget(c888000027.attg)
	e4:SetOperation(c888000027.atop)
	c:RegisterEffect(e4)
	--attach
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(888000027,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c888000027.ovcon)
	e5:SetTarget(c888000027.ovtg)
	e5:SetOperation(c888000027.ovop)
	c:RegisterEffect(e5)
	--detach
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(888000027,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c888000027.detop)
	c:RegisterEffect(e6)
	--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c888000027.val)
	c:RegisterEffect(e7)
end
function c888000027.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end	
function c888000027.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c888000027.ovfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c888000027.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if chk==0 then return Duel.IsExistingMatchingCard(c888000027.ovfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c888000027.ovfilter,tp,LOCATION_MZONE,0,2,2,nil)
	og=Group.CreateGroup()
	og:Merge(g)
	c:SetMaterial(og)
	Duel.Overlay(c,g)
end
function c888000027.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e:GetHandler():RegisterEffect(e1)
end
function c888000027.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
end
function c888000027.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local tc=sg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	while tc do
		Duel.CalculateDamage(c,tc)
		if tc:IsDefensePos() then
			if c:GetAttack()>tc:GetAttack() then
				tc:RegisterFlagEffect(888000027,RESET_CHAIN,0,1)
			elseif c:GetAttack()<tc:GetAttack() then
				local dif=tc:GetAttack()-c:GetAttack()
				Duel.Damage(c:GetControler(),dif,REASON_BATTLE)
			end
		else
			if c:GetAttack()>tc:GetAttack() then
				tc:RegisterFlagEffect(888000027,RESET_CHAIN,0,1)
				local dif=c:GetAttack()-tc:GetAttack()
				Duel.Damage(tc:GetControler(),dif,REASON_BATTLE)
			elseif c:GetAttack()<tc:GetAttack() then
				c:RegisterFlagEffect(888000027,RESET_CHAIN,0,1)
				local dif=tc:GetAttack()-c:GetAttack()
				Duel.Damage(c:GetControler(),dif,REASON_BATTLE)
			else
				c:RegisterFlagEffect(888000027,RESET_CHAIN,0,1)
				tc:RegisterFlagEffect(888000027,RESET_CHAIN,0,1)
			end
		end
		tc=sg:GetNext()
	end
	local des=Duel.GetMatchingGroup(c888000027.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(des,REASON_BATTLE)
end
function c888000027.desfilter(c)
	return c:GetFlagEffect(888000027)>0
end
function c888000027.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c888000027.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c888000027.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888000027.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c888000027.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c888000027.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c888000027.detop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,1,1)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c888000027.val(e,c)
	return Duel.GetOverlayGroup(0,1,1):GetCount()*300
end
function c888000027.ofilter(c)
	return c:GetOverlayCount()~=0
end
function c888000027.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local wg=Duel.GetMatchingGroup(c888000027.ofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local wbc=wg:GetFirst()
	local g=Group.CreateGroup()
	while wbc do
		if wbc:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TOKEN) then
			local ov=wbc:GetOverlayGroup()
			local ov1=ov:GetFirst()
			while ov1 do
				if ov1:IsType(TYPE_TOKEN) then
					g:AddCard(ov1)
				end
				ov1=ov:GetNext()
			end
		end
		wbc=wg:GetNext()
	end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(888000027)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_SEND_REPLACE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetTarget(c888000027.reptg)
			e1:SetOperation(c888000027.repop)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(888000027,EVENT_ADJUST,0,1) 	
		end
		tc=g:GetNext()
	end
end
function c888000027.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return true
end
function c888000027.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(c,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	else
		Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	Duel.Destroy(c,REASON_RULE)
	Duel.Release(c,REASON_RULE)
	Duel.SendtoGrave(c,REASON_RULE)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
end
function c888000027.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_TOKEN) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
			elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			elseif Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
				Duel.MoveToField(tc,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
			else
				Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			Duel.Destroy(tc,REASON_RULE)
			Duel.Release(tc,REASON_RULE)
			Duel.SendtoGrave(tc,REASON_RULE)
			Duel.Remove(tc,POS_FACEUP,REASON_RULE)
		end
		tc=g:GetNext()
	end
end
